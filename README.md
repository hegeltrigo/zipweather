# 🌤️ Global Weather Forecast App

A Ruby on Rails application that provides weather forecasts for any ZIP code worldwide using the OpenWeatherMap API.

![Weather App Screenshot](![alt text](image.png))
![Cache Cleared Screenshot](![alt text](image-1.png))

## ✨ Features

- **Global ZIP Code Support**: Get weather data for any ZIP code worldwide
- **Smart Caching**: Automatic 30-minute caching to reduce API calls
- **Cache Indicators**: Visual indicators showing when data comes from cache vs fresh API data
- **Cache Management**: One-click cache clearing functionality
- **Responsive Design**: Clean, user-friendly interface

## 🚀 Getting Started

### Prerequisites

- Ruby 3.0+
- Rails 7.0+
- OpenWeatherMap API account

### Step 1: Get OpenWeatherMap API Key

1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Create a free account
3. Navigate to API Keys section
4. Generate a new API key or use your default key

### Step 2: Set Up API Key in Rails

Add your API key to Rails credentials:

```bash
# Edit credentials (will open in your default editor)
EDITOR="code --wait" rails credentials:edit