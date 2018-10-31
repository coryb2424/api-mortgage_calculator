# README

This APP is a Mortgage Calulator API with three endpoints.

## INSTRUCTIONS:
  1. Download/clone the repo
  2. Navigate to folder in your terminal window
  3. start rails server: rails s
  4. Open Postmam, browser, other
  5. The app is on: localhost:3000

## ENDPOINTS
**1. GET /payment-amount**
_Returns the payment amount for the given schedule_
  
**Params:**
  - asking_price (INT):
  - down_payment (INT): at least 5% of first $500k plus 10% of any amount above $500k 
  - amortization_period (INT): Min 5 years, max 25 years
  - payment_schedule (STRING): weekly, biweekly, monthly

**Example:**
Call: `localhost:3000/payment-amount?asking_price=750000&down_payment=50000&payment_schedule=monthly&amortization_period=16`

Params:
```JSON 
{
  "asking_price": 750000,
  "down_payment": 50000,
  "payment_schedule": "monthly",
  "amortization_period": 16
}
```
Returns:
```JSON
{
  "amount": 4566.69
}
```

**2. GET /mortgage-amount**

_Returns the maximum mortgage given the parameters_

**Params:**
- payment_amount (INT):
- down_payment (INT): at least 5% of first $500k plus 10% of any amount above $500k
- amortization_period (INT): Min 5 years, max 25 years
- payment_schedule (STRING): weekly, biweekly, monthly


**Example:**
    Call: `localhost:3000/mortgage-amount?payment_amount=2500&down_payment=50000&payment_schedule=monthly&amortization_period=12`
    
Params:
```JSON
{
  "payment_amount": 2500,
  "down_payment": 50000,
  "payment_schedule": "monthly",
  "amortization_period": 12
}
```
 Returns:
```JSON
{
  "amount": 360740.67
}
```

**3. PATCH /interest-rate**
_Changes the App's interest rate_

**Params:**
- interest_rate (INT):

**Example:**
Call: `localhost:3000/interest-rate?interest_rate=4.7`

Params:
```JSON
{
  "interest_rate": 4.7
}
```
Returns:
```JSON
{
  "old_rate": 2.5,
  "new_rate": 4.7
}
```
