module Api
  module DistanceMatrix
    class Request
      attr_accessor :query

      def initialize(o_lat, o_lng, d_lat, d_lng)
        @query = {
          origins: o_lat.to_s + ',' + o_lng.to_s,
          destinations: d_lat.to_s + ',' + d_lng.to_s,
          mode: 'walking',
          language: 'ja-JA',
          key: ENV['GOOGLE_CLOUD_API']
        }
      end

      def request
        client = HTTPClient.new
        request = client.get(ENV['DISTANCE_MATRIX_URI'], query)
        JSON.parse(request.body)
      end

      def self.attributes_for(attrs)
        {
          duration: attrs['rows'][0]['elements'][0]['duration']['text'],
          distance: attrs['rows'][0]['elements'][0]['distance']['text']
        }
      end
    end
  end
end
