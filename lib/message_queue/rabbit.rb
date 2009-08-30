require 'carrot'
module MessageQueue
  class Rabbit < Base

    def initialize(opts={})
      @opts = opts
    end

    def delete(queue)
      send_command do
        client.queue(queue).delete
      end
    end

    def queue_size(queue)
      send_command do
        client.queue(queue).message_count
      end
    end

    def enqueue(queue, data, serializer)
      send_command do 
        client.queue(queue, :durable => true).publish(serializer.serialize(data), :persistent => true)
      end
    end

    def dequeue(queue, serializer)
      send_command do
        task = client.queue(queue).pop(:ack => true)
        return unless task
        serializer.deserialize(task)
      end
    end

    def confirm(queue)
      send_command do
        client.queue(queue).ack
      end
    end

    def send_command(&block)
      retried = false
      begin
        block.call
      rescue Carrot::AMQP::Server::ServerDown => e
        if not retried
          puts "Error #{e.message}. Retrying..."
          @client = nil
          retried = true
          retry
        else
          raise e
        end
      end
    end

    def client
      @client ||= Carrot.new(
        :host   => @opts['host'], 
        :port   => @opts['port'].to_i, 
        :user   => @opts['user'], 
        :pass   => @opts['pass'], 
        :vhost  => @opts['vhost'],
        :insist => @opts['insist']
      ) 
    end

    def stop
      client.stop
    end
  end
end
