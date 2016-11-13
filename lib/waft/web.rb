require 'waft/service'
require 'rack'
require 'rack/router'
require 'json'

module Waft
  class Web
    class API
      def initialize(password, filename)
        @service = Waft::Service.new(password, filename)

        me = self

        @router = Rack::Router.new do
          get    '/favicon.ico' => ->(env) { [ 204, {}, [] ] }
          post   '/entry/'      =>
            ->(env) {
              req = Rack::Request.new(env)
              me.create(req)
            }
          get    '/entry/'                     => ->(env) { me.list }
          get    '/entry/:id'                  => ->(env) { me.get(me.route_param(env, :id)) }
          put    '/entry/:id'                  => ->(env) { me.set(me.route_param(env, :id)) }
          delete '/entry/:id'                  => ->(env) { me.delete(me.route_param(env, :id)) }
          get    '/entry/:id/otp'              => ->(env) { me.otp(me.route_param(env, :id)) }
          get    '/entry/:id/provision/qr.png' => ->(env) { me.qr(me.route_param(env, :id)) }
        end
      end

      def list
        body = {
          entries: @service.list.map.with_index(1) { |entry, i|
            {
              index:   i,
              account: entry.account,
              issuer:  entry.issuer,
            }
          }
        }

        Rack::Response.new do |res|
          res.header['Content-type'] = 'application/json; charset=UTF-8'
          res.body = [ JSON.generate(body) ]
        end
      end

      def create(req)
        body = JSON.parse(req.body, symbolize_name: true)
        @service.add(Waft::Entity.new(body))
        [ 204, {}, [] ]
      end

      def get(id)
        entry = @service.get(id.to_i).dup
        body = {
          index:   id,
          account: entry.account,
          issuer:  entry.issuer,
          secret:  entry.secret,
        }

        Rack::Response.new do |res|
          res.header['Content-type'] = 'application/json; charset=UTF-8'
          res.body = [ JSON.generate(body) ]
        end
      end

      def set(id)
        body = JSON.parse(req.body, symbolize_name: true)
        @service.set(id.to_i, Waft::Entity.new(body))

        [ 204, {}, [] ]
      end

      def delete(id)
        entry = @service.delete(id.to_i)
        [ 204, {}, [] ]
      end

      def otp(id)
        body = {
          otp: @service.get(id.to_i).otp
        }

        Rack::Response.new do |res|
          res.header['Content-type'] = 'application/json; charset=UTF-8'
          res.body = [ JSON.generate(body) ]
        end
      end

      def qr(id)
        body = @service.get(id.to_i).qr(level: :m).as_png.to_s

        Rack::Response.new do |res|
          res.header['Content-type'] = 'image/png'
          res.body = [ body ]
        end
      end

      def call(env)
        @router.call(env)
      end

      def route_param(env, key)
        env['rack.route_params'][key]
      end
    end

    class RewriteIndex
      def initialize(app)
        @app = app
      end

      def call(env)
        if env['PATH_INFO'] == '/'
          env['PATH_INFO'] = '/static/index.html'
        end

        @app.call(env)
      end
    end

    def initialize(opts)
      password = opts[:password] or raise 'password is mandatory'
      filename = opts[:filename] or raise 'filename is mandatory'

      root = File.expand_path('../static', __FILE__)

      @app = RewriteIndex.new(
        Rack::Static.new(
          Waft::Web::API.new(password, filename),
          {
            :root => root,
            :urls => [ '/static' ],
          }
        )
      )
    end

    def call(env)
      @app.call(env)
    end
  end
end