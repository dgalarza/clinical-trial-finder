Geocoder.configure(
  lookup: :google,
  language: :en,
  api_key: ENV.fetch("GOOGLE_GEOCODING_API_KEY")
)
