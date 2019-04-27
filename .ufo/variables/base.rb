# Example ufo/variables/base.rb
# More info on how variables work: http://ufoships.com/docs/variables/
@image = helper.full_image_name # includes the git sha tongueroo/demo-ufo:ufo-[sha].
@environment = helper.env_file(".env")
@cpu = 256
@memory = 512
@memory_reservation = 512

# required for fargate
# @execution_role_arn = "..."
