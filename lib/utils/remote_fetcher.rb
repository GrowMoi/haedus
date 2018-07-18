require "net/http"

module Utils
  class RemoteFetcher
    class << self
      def fetch(uri_str, limit = 10)
        raise ArgumentError, 'too many HTTP redirects' if limit == 0

        response = Net::HTTP.get_response(URI(uri_str))

        case response
        when Net::HTTPSuccess then
          response
        when Net::HTTPRedirection then
          location = response['location']
          warn "redirected to #{location}"
          fetch(location, limit - 1)
        else
          response.value
        end
      end

      def fetch_value(uri_str)
        fetch(uri_str).value
      end
    end
  end
end
