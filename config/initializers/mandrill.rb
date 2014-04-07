MANDRILL_CONFIG = YAML.load(File.read(File.expand_path("#{Rails.root}/config/mandrill.yml", __FILE__)))
MANDRILL_CONFIG.merge! DISQUS_CONFIG.fetch(Rails.env, {})