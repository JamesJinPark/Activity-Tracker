# == Schema Information
#
# Table name: patients
#
#  id                            :integer          not null, primary key
#  email                         :string           default(""), not null
#  encrypted_password            :string           default(""), not null
#  reset_password_token          :string
#  reset_password_sent_at        :datetime
#  remember_created_at           :datetime
#  sign_in_count                 :integer          default(0), not null
#  current_sign_in_at            :datetime
#  last_sign_in_at               :datetime
#  current_sign_in_ip            :string
#  last_sign_in_ip               :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  name                          :string
#  dob                           :string
#  mrn                           :integer
#  withings_token_key            :string
#  withings_token_secret         :string
#  withings_id                   :integer
#  withings_request_token_secret :string
#  withings_authorized           :boolean
#  moves_id                      :string
#  moves_authorized              :boolean
#  moves_access_token            :string
#  moves_refresh_token           :string
#  fitbit_id                     :string
#  fitbit_authorized             :boolean
#  fitbit_access_token           :string
#  fitbit_refresh_token          :string
#

require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
