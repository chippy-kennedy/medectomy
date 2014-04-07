DISQUS_CONFIG = YAML.load(File.read(File.expand_path("#{Rails.root}/config/disqus.yml", __FILE__)))
DISQUS_CONFIG.merge! DISQUS_CONFIG.fetch(Rails.env, {})