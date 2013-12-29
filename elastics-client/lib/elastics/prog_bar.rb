module Elastics
  class ProgBar

    attr_reader :pbar, :total_count

    def initialize(total_count, batch_size=nil, prefix_message=nil)
      @successful_count = 0
      @failed_count     = 0
      puts
      message = "#{prefix_message}Processing #{total_count} documents"
      message << " in batches of #{batch_size}" unless batch_size.nil?
      Prompter.say_log message
      @pbar             = ::ProgressBar.create(:title         => title(:ok),
                                               :total         => total_count,
                                               :progress_mark => (Dye.color? ? ' ' : '|'),
                                               :format        => ('%t%c/%C %p%% %E %b' + dye(:background, '%i', '%i')))
    end

    def process_result(result, inc)
      unless result.nil? || result.empty?
        if result.failed.size > 0
          Conf.logger.error "Failed load:\n#{result.failed.to_yaml}"
          @pbar.title         = title(:failed)
          @pbar.progress_mark = 'F' unless Dye.color?
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
      Prompter.say_log     "Processed #{@pbar.total}. "
      Prompter.say_ok      "Successful #{@successful_count}. "
      Prompter.say_notice  "Skipped #{@pbar.total - @successful_count - @failed_count}. "
      Prompter.say_warning "Failed #{@failed_count}.", :mute => true
      Prompter.say_warning "See the log for the details about the #{@failed_count} failures." unless @failed_count == 0
    end

  private

    def title(how)
      return '' unless Dye.color?
      Dye.sgr(:clear, color(how), :reversed, :bold) + ' '
    end

    def dye(how, colored, plain)
      Dye.dye colored, plain, :reversed, :bold, color(how)
    end

    def color(how)
      case how
      when :background then :blue
      when :ok         then :green
      when :failed     then :red
      end
    end

  end
end
