# README

This APP is a Mortgage Calulator API with three endpoints.

INSTRUCTIONS:
  1. Download/clone
  2. start rails server: rails s
  3. Open Postmam, browser, other
  4. The app is on: localhost:3000

1. GET /payment-amount
  Returns the payment amount for the given schedule
  
  Params:
    - asking_price (INT):
    - down_payment (INT): at least 5% of first $500k plus 10% of any amount above $500k 
    - amortization_period (INT): Min 5 years, max 25 years
    - payment_schedule (STRING): weekly, biweekly, monthly
  
  Example: 
    Call: localhost:3000/payment-amount?asking_price=750000&down_payment=50000&payment_schedule=monthly&amortization_period=16
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
  Returns the maximum mortgage given the parameters

  Params:
    - payment_amount (INT):
    - down_payment (INT): at least 5% of first $500k plus 10% of any amount above $500k
    - amortization_period (INT): Min 5 years, max 25 years
    - payment_schedule (STRING): weekly, biweekly, monthly

  Example:
    Call: localhost:3000/mortgage-amount?payment_amount=2500&down_payment=50000&payment_schedule=monthly&amortization_period=12    
    Params:
      {
        payment_amount: 2500,
        down_payment: 50000,
        payment_schedule: monthly,
        amortization_period: 12
      }
    Returns:
      {
        "amount": 360740.67
      }

3. PATCH /interest-rate
  Changes the App's interest rate

  Params:
    - interest_rate (INT):

  Example: 
    Call: localhost:3000/interest-rate?interest_rate=4.7    
    Params:
      {
        interest_rate: 4.7
      }
    Returns:
      {
        "old_rate": 2.5,
        "new_rate": 4.7
      }
