# frozen_string_literal: true

#
# Class Settings::Search provides a means of easily
# looking up transfer templates by name.
#
class Settings::Search < Settings::Base
  # These helper methods avoid the need to little the code with custom strings
  define_helper_method :assets_by_barcode, 'Find assets by barcode'
  define_helper_method :qcables_by_barcode, 'Find qcable by barcode'
  define_helper_method :source_by_parent_barcode, 'Find source assets by destination asset barcode'
  define_helper_method :user_by_swipecard, 'Find user by swipecard code'
end
