# frozen_string_literal: true

#
# Class Settings::Purposes provides a means of easily
# looking up purpose configs by name.
#
class Settings::Purpose < Settings::Base
  class PurposeConfig
    include ActiveModel::Model
    attr_accessor :name, :asset_type, :stock_plate, :cherrypickable_target,
                  :input_plate, :transfer_template,  :parents, :tag_layout_templates
    attr_writer :state_changer_class, :presenter_class, :creator_class

    DEFAULTS = {
      creator_class: 'LabwareCreators::Base',
      presenter_class: 'Presenters::StandardPresenter',
      state_changer_class: 'StateChangers::DefaultStateChanger'
    }

    def initialize(parameters)
      super(DEFAULTS.merge(parameters))
    end

    def state_changer_class
      @state_changer_class.constantize
    end

    def presenter_class
      @presenter_class.constantize
    end

    def creator_class
      @creator_class.constantize
    end
  end

  def initialize(purpose_config: config_path)
    @purposes = extract_purposes(YAML.load_file(purpose_config))
    super()
  end

  def config_for(uuid)
    index_configs
    @indexed_configs.fetch(uuid)
  end

  private

  def index_configs
    @indexed_configs ||= @purposes.index_by {|purpose| uuid_for(purpose.name) }
  end

  def extract_purposes(configs)
    configs.map do |name, settings|
      settings[:name] = name
      PurposeConfig.new(settings)
    end
  end
end
