module MessageQueue
  class Base
    attr_reader :opts
    def queue_size(queue);    end
    def enqueue(queue, data, serializer); end
    def dequeue(queue, serializer);       end
    def confirm(queue);       end
    def subscribe(queue);     end
    def delete(queue);        end
    def client;               end
    def stop;                 end

    def subscribe?
      false
    end
  end
end
