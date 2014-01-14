require 'strscan'
# require 'pry'
# require 'pry-debugger'

module MailExtract
  class Parser
    attr_reader :body, :results

    # Initialize a new MailExtract::Parser object
    #
    # text    - Email message body
    # options - Parsing options
    #
    # Parsing options include:
    #   :only_head - Skip the rest of the message after quote start (default: false)
    #
    def initialize(text, options={})
      @lines     = []
      @text      = text.strip
      @body      = ""
      @last_type = :text
      @type      = :text
      @options   = options
      @results   = { text: [], quote: [], signature: [] }

      parse
    end

    def text
      @results[:text]
    end
    alias :text :body

    def quote
      @results[:quote]
    end

    def signature
      @results[:signature]
    end

    private

    # Process email message body
    #
    def parse
      break_after_quote = @options[:only_head] || false
      scanner = StringScanner.new(@text)

      # Process until message end
      while str = scanner.scan_until(/\n/)
        line = parse_line(str)

        if break_after_quote
          break if line.quote? && line.subtype == :start
        end
      end

      # Process the rest (if any)
      if !break_after_quote
        if (last_line = scanner.rest.to_s).size > 0
          parse_line(last_line)
        end
      end

      @results = @results.inject({}) do |hash, (key, value)|
        hash[key] = value.join("\n").strip
        hash
      end

      @body = @results[:text]
    end

    # Process a single line
    #
    def parse_line(str)
      line = MailExtract::Line.new(str)

      if line.quote?
        if @last_type == :text      ; @type = :quote     ; end
      elsif line.text?
        if @last_type == :quote     ; @type = :text      ; end
        if @last_type == :signature ; @type = :signature ; end
      elsif line.signature?
        if @last_type == :text      ; @type = :signature ;
        elsif @last_type == :quote  ; @type = :quote     ; end
      end
      @last_type = line.type
      @lines << line.body.strip if @type == :text
      @results[@type] << line.body.strip

      line
    end
  end
end