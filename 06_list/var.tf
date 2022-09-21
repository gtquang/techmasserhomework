variable "user_names" {
  description = "Create IAM users"
  type        = list(object({    //Định nghĩa kiểu object
    name = string,
    department = string
  }))
  default     = [{ 
      name = "Paul"
      department = "Sales"
    },
    { 
      name = "John"
      department = "Software"
    },
    { 
      name = "Hai"
      department = "Accounting"
    }]
}