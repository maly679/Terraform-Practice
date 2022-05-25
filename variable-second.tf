#Only need to include once in the main provider module in the following format:

#   default_tags {
#    tags = var.required_tags
#  }

# Will cause all dependencies to inheret the tags specefied
variable "required_tags"  {
    type = map
    
    default = ({
    Cost-Center = "55332"
    Environment = "Test"
    Owner = "james@q.com"

# Any optional tags can be included with null as the value and it will not appear as a tag.

    Business-Unit = null
    Budget = null
    
  })

}
