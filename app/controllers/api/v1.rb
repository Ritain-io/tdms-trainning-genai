# frozen_string_literal: true

module Api
  module V1
    INVALID_AUTH_TOKEN_MESSAGE             = 'Invalid auth_token'
    INVALID_APP_TOKEN_MESSAGE              = 'Invalid app_token'
    APPLICATION_REVOKED_MESSAGE            = 'This application is revoked'
    NOT_AUTHORIZED                         = 'Unauthorized'
    INVALID_PARAMETERS                     = 'Invalid parameters'
    RECORD_NOT_FOUND                       = 'Could not find record'
    MIN_LIMIT                              = 'You need to have at least one!'
    EXISTING_RECORD_FOR_THIS_DATE          = 'There is already a strategy for this start date!'
    STORAGE_FILE_NOT_EXISTS                = 'Could not find file on storage!'
    CONTACT_SUPPORT_ACCOUNT                = 'Contact support account: support@zenprice.com.'
    EXISTING_RECORD_FOR_ALERT              = 'There is already a alert with this settings!'

    MAX_DATE_RANGE = 31

    LIMIT = 500
  end
end
