class ProgressBar
  module Format
    class Base
      # see https://github.com/jfelchner/ruby-progressbar/pull/50
      def process(environment)
        processed_string = @format_string.dup

        non_bar_molecules.each do |molecule|
          processed_string.gsub!("%#{molecule.key}", environment.send(molecule.method_name).to_s)
        end

        remaining_molecules = bar_molecules.size
        placeholder_length  = remaining_molecules * 2

        processed_string.gsub! '%%', '%'
        processed_string_length = processed_string.gsub(/\e\[[\d;]+m/, '').length
        leftover_bar_length = environment.send(:length) - processed_string_length + placeholder_length
        leftover_bar_length = leftover_bar_length < 0 ? 0 : leftover_bar_length

        bar_molecules.each do |molecule|
          processed_string.gsub!("%#{molecule.key}", environment.send(molecule.method_name, leftover_bar_length).to_s)
        end

        processed_string
      end
    end
  end
end

module Elastics
  class ProgBar

    attr_reader :pbar, :total_count

    def initialize(total_count, batch_size=nil, prefix_message=nil)
      @successful_count = 0
      @failed_count     = 0
      # we use the title to pass the sgr start style codes
      start_style   = Dye.color? ? "#{Dye.sgr(:clear, :green, :reversed, :bold)} " : ''
      format        = '%t%c/%C %p%% %E %b'
      format       += Dye.sgr(:clear) if Dye.color?
      progress_mark = Dye.color? ? ' ' : '|'
      @pbar         = ::ProgressBar.create(:title         => start_style,
                                           :total         => total_count,
                                           :progress_mark => progress_mark,
                                           :format        => format )
      @pbar.clear
      puts
      message = "#{prefix_message}Processing #{total_count} documents"
      message << " in batches of #{batch_size}" unless batch_size.nil?
      Prompter.say_log message
      @pbar.start
    end

    def process_result(result, inc)
      unless result.nil? || result.empty?
        if result.failed.size > 0
          Conf.logger.error "Failed load:\n#{result.failed.to_yaml}"
          @pbar.title         = "#{Dye.sgr(:clear, :red, :reversed, :bold)} " if Dye.color?
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

  end
end
