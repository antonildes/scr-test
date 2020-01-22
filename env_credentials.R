library(config)
Sys.setenv(R_CONFIG_ACTIVE = "default")
config <- config::get(file = "config.yml")
config$AWS_ACCESS_KEY_ID
