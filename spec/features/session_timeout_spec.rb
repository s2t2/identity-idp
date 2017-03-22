require 'rails_helper'

feature 'Session Timeout' do
  context 'when SP info no longer in session but issuer params exists' do
    it 'preserves the branded experience' do
      issuer = 'http://localhost:3000'
      sp = ServiceProvider.from_issuer(issuer)
      visit root_path(issuer: issuer)

      expect(page).to have_link sp.friendly_name
      expect(page).to have_css('img[src*=sp-logos]')
    end
  end

  context 'when SP info is in session' do
    it 'displays the branded experience' do
      issuer = 'http://localhost:3000'
      sp = ServiceProvider.from_issuer(issuer)
      sp_session = { issuer: issuer }
      page.set_rack_session(sp: sp_session)
      visit root_path

      expect(page).to have_link sp.friendly_name
      expect(page).to have_css('img[src*=sp-logos]')
    end
  end
end