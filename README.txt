# README

This APP is a Mortgage Calulator API with three endpoints.

1. GET /payment-amount
  Returns the payment amount for the given schedule
  
  Params:
    - asking\_price (INT):
    - down\_payment (INT): at least 5% of first $500k plus 10% of any amount above $500k 
    - amortization\_period (INT): Min 5 years, max 25 years
    - payment\_schedule (STRING): weekly, biweekly, monthly
  
  Example: 
    Call: HOST/payment-amount?asking\_price=750000&down\_payment=50000&payment\_schedule=monthly&amortization\_period=16
    Params:
      {
        asking_price: 750000,
        down_payment: 50000,
        payment_schedule: monthly,
        amortization_period: 16
      }    
    Returns:
      {
        "amount": 4566.69
      }

2. GET /mortgage-amount
  Returns the maximum mortgage given the parameters_

  Params:
    - payment\_amount (INT):
    - down\_payment (INT): at least 5% of first $500k plus 10% of any amount above $500k
    - amortization\_period (INT): Min 5 years, max 25 years
    - payment\_schedule (STRING): weekly, biweekly, monthly

  Example:HOST/mortgage-amount?payment\_amount=2500&down\_payment=50000&payment\_schedule=monthly&amortization\_period=12
    
    Params:
       ```
        {
            payment_amount: 2500,
            down_payment: 50000,
            payment_schedule: monthly,
            amortization_period: 12
        }
      ```

    Returns:
      ```
         {
             "amount": 360740.67
         }
      ```

3. PATCH /interest-rate

  _Changes the App's interest rate_

  Params:
    - interest\_rate (INT):

  Example: HOST/interest-rate?interest\_rate=4.7
    
  Params:
       ```
        {
          interest_rate: 4.7
        }
      ```
    
   Returns:
      ```
        {
          "old_rate": 2.5,
          "new_rate": 4.7
        }
      ```
