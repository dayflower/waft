require 'waft/service'
require 'highline'

module Waft
  module CLI
    class Shell
      class Command; end

      def self.run
        self.new.run
      end

      def initialize
        @cli = HighLine.new

        password = ENV['WAFT_PASSWORD'] || self.getpass
        filename = ENV['WAFT_FILE'] || 'password.db'
        @service = Waft::Service.new(password, filename)
      end

      def getpass
        @cli.ask('password: ') { |q| q.echo = '*' }
      end

      def run
        loop do
          begin
            command = @cli.ask('> ', Command)
            command.execute(@cli, @service)
          rescue EOFError
            break
          end
        end
      end

      class Command
        def initialize(command, args)
          @command = command
          @args = args
        end

        def execute(cli, service)
          @cli = cli
          @service = service
          self.send(@command, *@args)
        end

        def exit
          raise EOFError.new
        end

        alias :bye :exit

        def list
          @service.list.map.with_index(1) { |entry, i|
            "##{i} #{entry.issuer || '(unspecified)'} #{entry.account}"
          }.each do |item|
            puts item
          end
        end

        def add(secret, account, issuer=nil)
          @service.add(Waft::Entity.new(secret: secret, account: account, issuer: issuer))
          puts 'added'
        end

        def delete(index)
          deleted = @service.delete(index.to_i - 1)
          puts "deleted #{deleted.account} of #{deleted.issuer || 'anonymous issuer'}"
        end

        alias :del :delete
        alias :remove :delete

        def code(index)
          puts @service.get(index.to_i - 1).otp
        end

        def qr(index)
          puts @service.get(index.to_i - 1).qr(level: :l).as_ansi
        end

        def secret(index)
          puts @service.get(index.to_i - 1).secret
        end

        def self.parse(str)
          args = str.split
          args = [ :help ] if args.empty?
          command = args.shift
          self.new(command, args)
        end
      end
    end
  end
end
