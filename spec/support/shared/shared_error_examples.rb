shared_examples 'a field that supports errors' do
  context 'when the attribute has errors' do
    before { object.valid? }

    specify 'an error message should be displayed' do
      expect(subject).to have_tag('span', with: { class: 'govuk-error-message' }, text: error_message)
    end

    specify 'the field element should have the correct error classes' do
      if error_class.present?
        expect(subject).to have_tag(field_type, with: { class: error_class })
      end
    end

    specify 'the error message should be associated with the correct element' do
      expect(subject).to have_tag(aria_described_by_target, with: { 'aria-describedby' => error_identifier })
      expect(subject).to have_tag('span', with: {
        class: 'govuk-error-message',
        id: error_identifier
      })
    end

    context 'when there is more than one error' do
      let(:first_error) { "It is totally wrong" }
      let(:second_error) { "Very wrong indeed" }
      let(:error_messages) { [first_error, second_error] }

      before do
        allow(object.errors.messages).to(
          receive(:[]).and_return(error_messages)
        )
      end

      specify 'the first error should be included' do
        expect(subject).to have_tag('span', text: Regexp.new(first_error))
      end

      specify 'the second error should not be included' do
        expect(subject).not_to have_tag('span', text: Regexp.new(second_error))
      end
    end
  end

  context 'when the attribute has no errors' do
    specify 'no error messages should be displayed' do
      expect(subject).not_to have_tag('span', with: { class: 'govuk-error-message' })
    end
  end
end
