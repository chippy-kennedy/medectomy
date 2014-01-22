S3_CONFIG = YAML.load(File.read(File.expand_path("#{Rails.root}/config/aws.yml", __FILE__)))
S3_CONFIG.merge! S3_CONFIG.fetch(Rails.env, {})
# S3_CONFIG.symbolize_keys!
