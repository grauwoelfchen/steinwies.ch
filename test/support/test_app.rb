require 'sbsm/drbserver'
require 'util/app'

module Steinwies
  class TestApp
    def initialize
      drb_url = TEST_APP_URI.to_s
      app = Steinwies::App.new

      @drb = Thread.new do
        begin
          DRb.stop_service
          @drb_server = DRb.start_service(drb_url, app)
          DRb.thread.join
        rescue Exception => e
          $stdout.puts e.class
          $stdout.puts e.message
          $stdout.puts e.backtrace
          raise
        end
      end
      @drb.abort_on_exception = true
      trap('INT') { @drb.exit }

      @http_server = Steinwies.http_server(drb_url)
      @http_server.shutdown
      trap('INT') { @http_server.shutdown }

      @server = Thread.new { @http_server.start }
      trap('INT') { @server.exit }

      @server
    end

    def exit
      @http_server.shutdown
      @http_server = nil

      @drb_server.stop_service
      @drb_server = nil
      @drb.exit
      @drb = nil

      @server.exit
      Thread.kill(@server)
      @server = nil
    end
  end
end
