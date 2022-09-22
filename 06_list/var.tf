variable "user_names" {
  description = "Create IAM users"
  type        = list(object({    //Định nghĩa kiểu object
    name = string,
    tags = map(string)
  }))
  default     = [{ 
      name = "Paul"
      tags = {
        "department" = "Sales"
      }
    },
    { 
      name = "John"
      tags = {
        "department" = "Software"
      }
    },
    { 
      name = "Hai"
      tags = {
        "department" = "Accounting"
      }
    }]
}