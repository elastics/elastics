module Elastics
  class ProgBar

    attr_reader :pbar, :total_count

    def initialize(total_count, batch_size=nil, prefix_message=nil)
      @successful_count = 0
      @failed_count     = 0
      @pbar             = ::ProgressBar.create(:total         => total_count,
                                               :progress_mark => '|',
                                               :format        => 'processing... |%b%i| %p%% %E',
                                               :length        => 80)
      @pbar.clear
      puts '_' * @pbar.send(:length)
      message = "#{prefix_message}Processing #{total_count} documents"
      message << " in batches of #{batch_size}:" unless batch_size.nil?
      puts message
      @pbar.start
    end

    def process_result(result, inc)
      unless result.nil? || result.empty?
        unless result.failed.size == 0
          Conf.logger.error "Failed load:\n#{result.failed.to_yaml}"
          @pbar.progress_mark = 'F'
        end
        @failed_count     += result.failed.size
        @successful_count += result.successful.size
      end
      new_progress   = @pbar.progress + inc
      # avoids an error in case progress > total (may happen in import)
      @pbar.total    = (new_progress + 1) if new_progress > @pbar.total
      @pbar.progress = new_progress
    end

    def finish
      @pbar.finish unless @pbar.finished?
      puts "Processed #{@pbar.total}. Successful #@successful_count. Skipped #{@pbar.total - @successful_count - @failed_count}. Failed #@failed_count."
      puts 'See the log for the details about the failures.' unless @failed_count == 0
    end

  end
end
