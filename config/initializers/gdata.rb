#GDATA_CONFIG = YAML.load(File.read(File.expand_path("#{Rails.root}/config/gdata.yml", __FILE__)))
#GDATA_CONFIG.merge! S3_CONFIG.fetch(Rails.env, {})
#S3_CONFIG.symbolize_keys!
