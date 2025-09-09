# app/controllers/weather_controller.rb
class WeatherController < ApplicationController
  def index
    @zip_code = params[:zip_code]&.strip
    
    # Handle cache clearing
    if params[:clear_cache] == 'true'
      clear_weather_cache
      @cache_cleared = true
      
      @forecast = nil
      @from_cache = false
      
      @zip_code = params[:zip_code] if params[:zip_code].present?
      
    elsif @zip_code.present?
      @cache_cleared = false
      service = WeatherService.new
      result = service.get_forecast_by_zip(@zip_code)
      
      @forecast = result[:forecast]
      @from_cache = result[:from_cache]
      
    else
      @cache_cleared = false
      @forecast = nil
      @from_cache = false
    end
  end

  private

  def clear_weather_cache
    Rails.cache.delete_matched("weather_*")
    puts "🧹 Cache cleared!" if Rails.env.development?
  end
end