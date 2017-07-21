require 'rails_helper'

feature 'Internationalization' do
  context 'visit homepage with no locale set' do
    it 'displays a header in the default locale' do
      visit root_path
      expect(page).to have_content t('headings.sign_in_without_sp', locale: 'en')
    end
  end

  context 'visit homepage with locale set in header' do
    before do
      page.driver.header 'Accept-Language', locale
      visit root_path
    end

    context 'when the user has set their locale to :en' do
      let(:locale) { :en }

      it 'displays a translated header to the user' do
        expect(page).to have_content t('headings.sign_in_without_sp', locale: 'en')
      end
    end

    context 'when the user has set their locale to :es' do
      let(:locale) { :es }

      it 'displays a translated header to the user' do
        expect(page).to have_content t('headings.sign_in_without_sp', locale: 'es')
      end
    end

    context 'when the user selects an unsupported locale' do
      let(:locale) { :es }

      it 'it does not raise an exception' do
        expect { visit root_path + '?locale=foo' }.to_not raise_exception
      end

      it 'it falls back to the locale set in header' do
        expect(page).to have_content t('headings.sign_in_without_sp', locale: 'es')
      end
    end
  end

  context 'visit homepage without a locale param set' do
    it 'displays header in the default locale' do
      visit '/'

      expect(page).to have_content t('headings.sign_in_without_sp', locale: 'en')
    end

    it 'allows user to manually toggle language from dropdown menu', js: true do
      visit root_path
      within(:css, '.i18n-desktop-dropdown', visible: false) do
        find_link(t('i18n.locale.es'), visible: false).trigger('click')
      end

      expect(page).to have_content t('headings.sign_in_without_sp', locale: 'es')
      expect(page).to have_content t('i18n.language', locale: 'es')

      within(:css, '.i18n-desktop-dropdown', visible: false) do
        find_link(t('i18n.locale.en'), visible: false).trigger('click')
      end

      expect(page).to have_content t('headings.sign_in_without_sp', locale: 'en')
      expect(page).to have_content t('i18n.language', locale: 'en')
    end
  end

  context 'visit homepage with locale param set to :es' do
    it 'displays a translated header to the user' do
      visit '/es/'

      expect(page).to have_content t('headings.sign_in_without_sp', locale: 'es')
    end
  end
end
