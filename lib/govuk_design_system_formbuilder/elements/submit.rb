module GOVUKDesignSystemFormBuilder
  module Elements
    class Submit < GOVUKDesignSystemFormBuilder::Base
      def initialize(builder, text, warning:, secondary:, prevent_double_click:, &block)
        @builder              = builder
        @text                 = text
        @prevent_double_click = prevent_double_click

        fail ArgumentError, 'buttons can be warning or secondary' if (warning && secondary)
        @warning = warning
        @secondary = secondary
        @block_content = @builder.capture { block.call } if block_given?
      end

      def html
        @builder.content_tag('div', class: %w(govuk-form-group)) do
          @builder.safe_join([
            @builder.submit(@text, class: submit_button_classes(@block_content.present?), **extra_args),
            @block_content
          ])
        end
      end
    private

      def submit_button_classes(content_present)
        %w(govuk-button).tap do |classes|
          classes.push('govuk-button--warning') if @warning
          classes.push('govuk-button--secondary') if @secondary

          # NOTE only this input will receive a right margin, block
          # contents must be addressed individually
          classes.push('govuk-!-margin-right-1') if content_present
        end
      end

      def extra_args
        { data: { 'prevent-double-click' => (@prevent_double_click || nil) }.compact }
      end
    end
  end
end