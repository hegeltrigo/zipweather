# app/services/weather_service.rb
require 'httparty'

class WeatherService
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'

  def initialize
    @api_key = Rails.application.credentials.openweather_api_key
  end

  def get_forecast_by_zip(zip_code)
    # Use a simple, consistent cache key
    cache_key = "weather_#{zip_code}"
    
    puts "=== CACHE DEBUG ==="
    puts "Cache key: #{cache_key}"
    puts "Cache exists?: #{Rails.cache.exist?(cache_key)}"
    
    # Check if cached data exists
    cached_data = Rails.cache.read(cache_key)
    
    if cached_data
      puts "✅ RETURNING FROM CACHE"
      return { forecast: cached_data, from_cache: true }
    end
    
    puts "❌ NO CACHE, FETCHING FROM API"
    
    # Fetch from API (simplified for testing)
    forecast = fetch_from_api(zip_code, 'US')
    
    if forecast && !forecast[:error]
      puts "💾 SAVING TO CACHE"
      Rails.cache.write(cache_key, forecast, expires_in: 30.minutes)
      puts "Cache saved?: #{Rails.cache.exist?(cache_key)}"
    end
    
    { forecast: forecast, from_cache: false }
  end

  private

  def fetch_from_api(zip_code, country_code)
    begin
      response = self.class.get('/weather', {
        query: {
          zip: "#{zip_code},#{country_code}",
          appid: @api_key,
          units: 'metric',
          lang: 'en'
        },
        timeout: 15
      })

      if response.success?
        data = response.parsed_response
        {
          current_temp: data.dig('main', 'temp')&.round(1),
          high: data.dig('main', 'temp_max')&.round(1),
          low: data.dig('main', 'temp_min')&.round(1),
          description: data.dig('weather', 0, 'description'),
          humidity: data.dig('main', 'humidity'),
          wind_speed: data.dig('wind', 'speed'),
          city: data['name'],
          country: data.dig('sys', 'country'),
          zip_code: zip_code,
          timestamp: Time.current
        }
      else
        { error: "API Error: #{response.code}" }
      end

    rescue => e
      { error: "Connection error: #{e.message}" }
    end
  end
end