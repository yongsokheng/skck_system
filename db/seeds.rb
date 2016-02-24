Company.create! name: "Framgia"
Company.create! name: "Microsoft"
Company.create! name: "Apple"
Company.create! name: "Samsung"

company = Company.first
company.users.create! name: "john", email: "admin@gmail.com", password: "12345678",
  password_confirmation: "12345678", role: 0

ChartAccountType.create! name: "Bank", type_code: "bank"
ChartAccountType.create! name: "Account Receivable", type_code: "ar"
ChartAccountType.create! name: "Account Payable", type_code: "ap"
ChartAccountType.create! name: "Cash", type_code: "cash"

company.chart_of_accounts.create! account_no: "1234", name: "ANZ Royal Bank", chart_account_type_id: 1
company.chart_of_accounts.create! account_no: "5678", name: "Account Receivable", chart_account_type_id: 2
company.chart_of_accounts.create! account_no: "9231", name: "Account Payable", chart_account_type_id: 3
company.chart_of_accounts.create! account_no: "9283", name: "Cash on hand", chart_account_type_id: 4

company.customer_venders.create! name: "customer", status: "Customer"
company.customer_venders.create! name: "vender", status: "Vender"
