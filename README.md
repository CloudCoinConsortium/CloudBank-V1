# CLOUDCOIN CONSORTIUM'S CLOUDBANK VERSION 10-22-2017 MIT LICENCE

This Software is provided as is with all faults, defects 
and errors, and without warranty of any kind.
Free from the CloudCoin Consortium.
                                                 

The purpose is to allow software to pown coins. 
Some examples of use:

You sell products from your website and want to accept CloudCoins as payment. 

You want to sell virtule goods in your minecraft server without worrying about charge backs.

You create an accounting system and want to recieve and export CloudCoins.



NOTES: To Stop Replay attacks and other sercurity concenrs, HTTPS.

For receiving CloudCoins, you may only need a few services. The other services may be shut down to reduce the security surface. Services that are neccessary include: Echo, (Deposite or Import One Stack), Get Receipt. The Print Welcome, Show Coins, Expot One Stack services can be shut off if you will collect your CloudCoins from the harddrive of the web server that runs CloudBank. 

Note that this fist phaze service uses file-based storage and not a database. 



Many ervices are available:
1. Print Welcome
2. Echo
3. Show Coins
4. Deposit One Stack
5. Withdraw One Stack
6. Get Receipt
7. Bill Pay
8. Write and Send Check
9. Cash Check

There are also standards for how the transactions will go:
1. Merchant / Buyer Collaboration
2. Buyer Initiated
3. Merchant Dominates
Note that these are still under development

------------------------------------------------------------------
Config file:
The following will be needed in app configurations:

bank_server =  https://CloudCoin.co/ (Use the name of the local host)

timezone = UTC-7 (use the customer's  timezone)

For security, the system admin must setup SSL and limit the servers that can connect to this web server. 
----------------------------------------------------------------
# Services
------------------------
## PRINT WELCOME SERVICE

Get's the bank's welcome information

Sample request
```
https://cloudcoin.global/bank/print_welcome.php
```
Response if success:
```
{
	"bank_server": "www.myBank.com",
	"status": "welcome",
	"version":"4.07.17",
	"message": "CloudCoin Bank. Used to Authenticate, Store and Payout CloudCoins. 
	This Software is provided as is with all faults, defects and errors, and without warranty of any kind.  
	Free from the CloudCoin Consortium.",
	"time": "2016-40-21 10:40:PM"
}
```

## ECHO RAIDA SERVICE

Sample GET Request:
```
https://CloudCoin.co/bank/echo.aspx
```

Echo Response for good
```
{
    "bank_server":"CloudCoin.co",
    "status":"ready",
    "message":"The RAIDA is ready for counterfeit detection.",
    "time":"2016-49-21 7:49:PM"
}
```

Echo Response for bad
```
{
    "bank_server":"CloudCoin.co",
    "status":"fail",
    "message":"Not enough RAIDA servers can be contacted to import new coins.",
    "time":"2016-49-21 7:49:PM"
}
```
Not enough RAIDA servers can be contacted to import new coins.

## DEPOSIT SERVICE 

The Deposite Service does exactly the same thing as the IMPORT ONE STACK service except it allows the caller to specify the receipt number that is to be used. This requires the POST request to use an rn (receipt number) parameter in the url. The receipt number must be a random GUID. There is an additional error that could happen. The caller could request the use of  a GUID that has already used. 

Sample POST Request:
```
https://CloudCoin.co/bank/import_one_stack.aspx?rn=640322f6d30c45328914b441ac0f4e5b
stack=
{
	"cloudcoin": [
		{ 
		"nn":"1", 
		"sn":"1112240", 
		"an": ["f5a52ee881daaae548c24a8eaff7176c", "415c2375a6fa48c4661f5af8d7c95541", "73e067b7b47c1556deebdca33f9a09fb", "9b90d265d102a565a702813fa2211f54", "e3e191ca987c8010a3adc49c6fc18417",
			"baa7578e207b7cfaa0b8336d7ed4a4f8", "6d8a5c66a589532fe9e5dc3932650cfa", "1170b354e097f2d90132869631409bd3", "b7bc83e8ee7529ff9f874866b901cf15", "a37f6c4af8fbcfbc4d77880fc29ddfbc",
			"277668208e9bafd9393aebd36945a2c3", "ef50088c8218afe53ce2ecd655c2c786", "b7bbb01fbe6c3a830a17bd9a842b46c0", "737360e18596d74d784f563ca729aaea", "e054a34f2790fd3353ea26e5d92d9d2f",
			"7051afef36dc388e65e982bc853be417", "ea22cbae0394f6c6918691f2e2f2e267", "95d1278f54b5daca5898c62f267b6364", "b98560e11b7142d1addf5b9cf32898da", "e325f615f93ed682c7aadf6b2d77c17a",
			"3e8f9d74290fe31d416b90db3a0d2ab1", "c92d1656ded0a4f68e5171c8331e0aea", "7a9cee66544934965bca0c0cb582ba73", "7a55437fa98c1b10d7f47d84f9accdf0", "c3577cced2d428f205355522bc1119b6"],
		"ed":"7-2019",
		"pown":"ppppppppppppppppppppppppp",
		"aoid": []
		}

	]
}
```

## DEPOSIT ONE STACK SERVICE

The program must put a stack file in a folder that is accessible via the web to cors on the CloudBank Server. 


Sample POST Request:
```
https://CloudCoin.co/bank/import_one_stack.aspx?
stack=
{
	"cloudcoin": [
		{ 
		"nn":"1", 
		"sn":"1112240", 
		"an": ["f5a52ee881daaae548c24a8eaff7176c", "415c2375a6fa48c4661f5af8d7c95541", "73e067b7b47c1556deebdca33f9a09fb", "9b90d265d102a565a702813fa2211f54", "e3e191ca987c8010a3adc49c6fc18417",
			"baa7578e207b7cfaa0b8336d7ed4a4f8", "6d8a5c66a589532fe9e5dc3932650cfa", "1170b354e097f2d90132869631409bd3", "b7bc83e8ee7529ff9f874866b901cf15", "a37f6c4af8fbcfbc4d77880fc29ddfbc",
			"277668208e9bafd9393aebd36945a2c3", "ef50088c8218afe53ce2ecd655c2c786", "b7bbb01fbe6c3a830a17bd9a842b46c0", "737360e18596d74d784f563ca729aaea", "e054a34f2790fd3353ea26e5d92d9d2f",
			"7051afef36dc388e65e982bc853be417", "ea22cbae0394f6c6918691f2e2f2e267", "95d1278f54b5daca5898c62f267b6364", "b98560e11b7142d1addf5b9cf32898da", "e325f615f93ed682c7aadf6b2d77c17a",
			"3e8f9d74290fe31d416b90db3a0d2ab1", "c92d1656ded0a4f68e5171c8331e0aea", "7a9cee66544934965bca0c0cb582ba73", "7a55437fa98c1b10d7f47d84f9accdf0", "c3577cced2d428f205355522bc1119b6"],
		"ed":"7-2019",
		"pown":"ppppppppppppppppppppppppp",
		"aoid": []
		}

	]
}
```


Sample Response if good:
```
{
 "bank_server":"CloudCoin.co",
 "status":"importing",
 "message":"The stack file has been imported and detection will begin automatically so long as they are not already in bank. Please check your reciept.",
 "reciept":"640322f6d30c45328914b441ac0f4e5b",
 "time":"2016-49-21 7:49:PM"
}
```

Sample Response if bad file bad:
```
{
 "bank_server":"CloudCoin.co",
 "status":"error",
 "message":"JSON: Your stack file was corrupted. Please check JSON validation.",
 "reciept":"640322f6d30c45328914b441ac0f4e5b",
 "time":"2016-49-21 7:49:PM"
}
```
Sample Response if nothing attached :
```
{
 "bank_server":"CloudCoin.co",
 "status":"error",
 "message":"LoadFile: The stack file was empty.",
 "reciept":"640322f6d30c45328914b441ac0f4e5b",
 "time":"2016-49-21 7:49:PM"
}
```

## GET RECEIPT SERVICE

The get receipt service returns a receipt based on the receipt id. 


### Sample Reciepts
If powning process has not been started
```
{
	"receipt_id": "e054a34f2790fd3353ea26e5d92d9d2f",
	"time": "2016-49-21 7:49:PM",
	"timezone": "UTC-7",
	"bank_server": "bank.CloudCoin.Global",
	"total_authentic": 5,
	"total_fracked": 7,
	"total_counterfeit": 1,
	"total_lost": 0,
	"receipt_detail": [{
			"nn.sn": "1.16777216",
			"status": "suspect",
			"pown": "uuuuuuuuuuuuuuuuuuuuuuuuu",
			"note": "Waiting"
		},
		{
			"nn.sn": "1:1425632",
			"status": "suspect",
			"pown": "uuuuuuuuuuuuuuuuuuuuuuuuu",
			"note": "Waiting"
		},
		{
			"nn.sn": "1.956258",
			"status": "suspect",
			"pown": "uuuuuuuuuuuuuuuuuuuuuuuuu",
			"note": "Waiting"
		},
		{
			"nn.sn": "1.15666214",
			"status": "suspect",
			"pown": "uuuuuuuuuuuuuuuuuuuuuuuuu",
			"note": "Waiting"
		},
		{
			"nn.sn": "1.15265894",
			"status": "suspect",
			"pown": "uuuuuuuuuuuuuuuuuuuuuuuuu",
			"note": "Waiting"
		}

	]

}
```

If powning process is complete:
```
{
        "receipt_id":"e054a34f2790fd3353ea26e5d92d9d2f",
	"time": "2016-49-21 7:49:PM",
	"timezone": "UTC-7",
	"bank_server": "bank.CloudCoin.Global",
	"total_authentic": 5,
	"total_fracked": 7,
	"total_counterfeit": 1,
	"total_lost": 0,
	"receipt_detail": [{
			"nn.sn": "1.16777216",
			"status": "authentic",
			"pown": "ppppppppepppppppppppeppp",
			"note": "Moved to Bank"
		},
		{
			"nn.sn": "1:1425632",
			"status": "counterfeit",
			"pown": "fffffffffpfffffffffffffff",
			"note": "Sent to trash"
		},
		{
			"nn.sn": "1.956258",
			"status": "authentic",
			"pown": "ppppppppppppppppppppppppf",
			"note": "Moved to Fracked"
		},
		{
			"nn.sn": "1.15666214",
			"status": "lost",
			"pown": "pfpfpfpfpfpfpfpfpfpfpfpfp",
			"note": "Moved to Lost"
		},
		{
			"nn.sn": "1.15265894",
			"status": "lost",
			"pown": "ppppffpeepfpppfpfffpfffpf",
			"note": "STRINGS ATTACHED!"
		}

	]

}
```
## SHOW COINS SERVICE 

Gets the totals of CloudCoins in the bank

Sample GET Request:

```
https://CloudCoin.co/bank/show_coins.aspx
```
Sample Response:
```
{
 "bank_server":"CloudCoin.co",
 "status":"coins_shown",
 "ones":205,
 "fives":10,
 "twentyfives":105,
 "hundreds":1050,
 "twohundredfifties":98,
 "time":"2016-49-21 7:49:PM"
}
```

## WITHDRAW ONE STACK SERVICE

Sample GET Request:

```
https://CloudCoin.co/bank/export_one_stack.aspx?tag=PaymentForSample&amount=254&sendby=download

phase 2: https://CloudCoin.co/bank/export_one_stack.aspx?tag=PaymentForSample&amount=254&sendby=email

phase 2: https://CloudCoin.co/bank/export_one_stack.aspx?tag=PaymentForSample&amount=254&sendby=url


```
sample response if good

```
{
	"cloudcoin": [
		{ 
		"nn":"1", 
		"sn":"1112240", 
		"an": ["f5a52ee881daaae548c24a8eaff7176c", "415c2375a6fa48c4661f5af8d7c95541", "73e067b7b47c1556deebdca33f9a09fb", "9b90d265d102a565a702813fa2211f54", "e3e191ca987c8010a3adc49c6fc18417",
			"baa7578e207b7cfaa0b8336d7ed4a4f8", "6d8a5c66a589532fe9e5dc3932650cfa", "1170b354e097f2d90132869631409bd3", "b7bc83e8ee7529ff9f874866b901cf15", "a37f6c4af8fbcfbc4d77880fc29ddfbc",
			"277668208e9bafd9393aebd36945a2c3", "ef50088c8218afe53ce2ecd655c2c786", "b7bbb01fbe6c3a830a17bd9a842b46c0", "737360e18596d74d784f563ca729aaea", "e054a34f2790fd3353ea26e5d92d9d2f",
			"7051afef36dc388e65e982bc853be417", "ea22cbae0394f6c6918691f2e2f2e267", "95d1278f54b5daca5898c62f267b6364", "b98560e11b7142d1addf5b9cf32898da", "e325f615f93ed682c7aadf6b2d77c17a",
			"3e8f9d74290fe31d416b90db3a0d2ab1", "c92d1656ded0a4f68e5171c8331e0aea", "7a9cee66544934965bca0c0cb582ba73", "7a55437fa98c1b10d7f47d84f9accdf0", "c3577cced2d428f205355522bc1119b6"],
		"ed":"7-2019",
		"pown":"ppppppppppppppppppppppppp",
		"aoid": []
		}

	]
}
```
## BILL PAY SERVICE

This is a task that is called every day. The program checks the Excel spreadsheet to see if bills need to be paid.The Excell spread sheet is a standardized spreadsheet.

FileName: BillPay
Sheets within: Reocurring, Pending and History
Column Headers:

### Reoccuring (
Used to mark payments that should be paid automatically each month. These records are not deleted. They will be checked everyday and payments assigned to that day of the month will be made and copied to the Pending folder. 
1. Status: Active or Deactive.
2. PAY TO THE ORDER OF ( Payee Name )
3. SEND TO EMAIL ( Payee Email )
4. ACCOUNT NUMBER OR MEMO 
5. DAY OF THE MONTH TO PAY ( Day of the month that checks will be sent out )
6. AMOUNT (Amount of CloudCoin to be sent )
7. SIGNED BY ( Who is sending the CloudCoins )
8. YOUR EMAIL ( Senders Email )
9. YOUR OTHER CONTACT INFO ( Other information that can be included to for contact )

### PayOnce 
The system checks this list once each day. The Bill pay will make the payment and send to pending. Then the payment is deleted from this list)
1. Status: Active or Deactive.
2. PAY TO THE ORDER OF ( Payee Name )
3. SEND TO EMAIL ( Payee Email )
4. ACCOUNT NUMBER OR MEMO 
5. DAY OF THE MONTH TO PAY ( Day of the month that checks will be sent out )
6. AMOUNT (Amount of CloudCoin to be sent )
7. SIGNED BY ( Who is sending the CloudCoins )
8. YOUR EMAIL ( Senders Email )
9. YOUR OTHER CONTACT INFO ( Other information that can be included to for contact )

### Pending
This holds all checks that have been sent but have not been cashed yet. Once they are cashed, they are deleted from pending and moved to  Paid. Payments in pending can be marked Cancel. If they are marked Cancel the money will be put back in the bank. Records will be checked for Cancel once each day. If they are marked as Hold. The check cashing service will not be allowed to give the user money until the status is changed to Pending. 
1. STATUS (Pending, Hold or Cancel)
2. CHECK GUID
3. PAY TO THE ORDER OF
4. SEND TO EMAIL
5. ACCOUNT NUMBER OR MEMO
6. DATE PAID
7. AMOUNT

### Paid
1. CHECK GUID
2. PAY TO THE ORDER OF
3. SEND TO EMAIL
4. ACCOUNT NUMBER OR MEMO
5. DATE PAID
6. AMOUNT

### Archive Month Year (e.g. Archive December 2017
Creates a sheet with all the payments from a month and year for historical purposes. 
1. CHECK GUID
2. PAY TO THE ORDER OF
3. SEND TO EMAIL
4. ACCOUNT NUMBER OR MEMO
5. DATE PAID
6. AMOUNT


Daily Actions:
The following actions will take place one or more times each day according to the configuration: 
1. Bill Pay looks at Reoccuring to see if a bill is to be paid. If yes, calls on the check making service to write a check.
2. Checks on the PayOnce to see if there is anything there. If yes, calls on the check maaking service and deletes the record from PayOnce.
3. Bill Pay looks at the Pending to see if and are canceled. PUt the canceled back into bank and deletes from pending. 
4. Bill Pay checks to see if records in Paid are more than one month old and places them in an Archive folder for the appropriate month. 


## WRITE & SEND CHECK SERVICE
1. Make a check: Creates a stack file with a GUID and saves it in the Check folder
In CloudBank, a Check is a url that point to a stack file that is located in the Check folder.

Example of a check:
```html

<html>
<body>
	<h1>Sean H. Wothington</h1>
	<address>1445 Heritage Oak Drive, Chico Ca, 95928</address>
	<email>CloudCoin@Protonmail.com</email>
	
	<h2>PAYTO THE ORDER OF: Larry's Landscaping</h2>
	<h2>AMOUNT: 59 CloudCoins</h2>
	
	
	
	
	<a href="https://Sean.CloudCoin.Global/checks.aspx?id=c3c3ab7b-75ab-4d08-9d2d-4a287c1ef232.stack">Cash Check Now</a>
	
	
</body>
<html>

https://Sean.CloudCoin.Global/checks.aspx?id=c3c3ab7b-75ab-4d08-9d2d-4a287c1ef232
```
Sample link to check:
```html
https://Sean.CloudCoin.Global/checks/c3c3ab7b-75ab-4d08-9d2d-4a287c1ef232.html
```
Sample link to cash check:
```html
hhttps://Sean.CloudCoin.Global/checks.aspx?id=c3c3ab7b-75ab-4d08-9d2d-4a287c1ef232
```
1. Gathers CloudCoins into a stack and puts the stack file into the "check" folder.
2. Emails a link to the check to the payee.
3. Writes the Check Id (GUID) to the excel spread sheet.
4. Writes the send date to the excel spread sheet.
5. Send email:
Subject: Check for 2440 CloudCoins
Contains link to check:

## CHECK CASHING SERVICE
Allows user to download CloudCoins based on a check number. 
1. Checks to see if the excel spread sheet has the check on hold. 
2. Gives the stack file that the users wants to the user.
3. Updates the spreadsheet to show the date cashed. 





# TRANSACTION METHODS

## Merchant / Buyer Collaboration

1. Merchant Creates receipt

   The Merchant totals the amount due and generates a random receipt number. Then the Merchant creates a URL and gives it to the Buyer. 
   
   Sample URL Sent to Buyer from Merchant: https://bank.mydomain.com/pay/deposite?rn=ea22cbae0394f6c6918691f2e2f2e267
   
2. Buyer Deposites in bank

   Buyer Uses URL and attaches stack file: https://bank.mydomain.com/pay/deposite?rn=ea22cbae0394f6c6918691f2e2f2e267

3. Buyer shows Merchant Proof of Purchase

4. Merchant Confirms Purchase with CloudBank.

Sample: https://bank.mydomain.com/pay/get_receipt?rn=ea22cbae0394f6c6918691f2e2f2e267

## Buyer Initiated
1. Buyer Estimates Receipt
2. Buyer Deposites in bank
3. Buyer shows Merchant Proof of Purchase
4. Merchant Confirms Purchase with CloudBank.

## Merchant Dominates
1. Merchant Creates receipt
2. Buyer give Merchant CloudCoins
3. Merchant Deposits CC in CloudBank
4. Merchant Confirms Purchase with CloudBank.




# ###################
## Account Service
# ##################

*ACCOUNT REQUEST STRING*

This service will do many things:

1. Create an account for a new user including their username, password,  email and folders for the user if none exists.
2. Change the password (if a new password is provided)
3. Change the email address (if a new email address is provided)
4. Semd email to user saying that the account has been created.
5. Send email to user saying that the password and or email has been changed.
6. Send username and password if only the email is sent. 

This service also will change the password of an existing account, change the email of a user and send the username and password to the user.  This will create a folder names after the account and populate it with the following subfolders:

* Bank
* Broke
* Counterfeit
* Export
* Fracked
* Import
* Imported
* Logs
* Lost
* Suspect
* Templates
* Trash
* Waiting

**rules for user account names**
Your users must have a unique identifier that allows your system to identify the accounts within the CloudBank. We call this unique identifer the "Account ID." This number will become the name of folders within the CloudBank. This folder could be a number (like a customer number) or a GUID or any thing that you use to uniquly identify your users in your system. 
However, there are some rules: 
Your Account ID must work as folder names for both Windows and Linux Operating sytems.
Account IDs cannot contain any of the following characters:
```
    \ / : * ? " ' < > | 
```
Your CloudBank may treat your Account identifiers as either case sensitive or case insensitive. This depends on if your CloudBank is hosted on a Linux (PHP) or Windows (C#) System. 

POST:
https://cloudcoin.global/bank/account.php?

uid=e24b3a755916472f8768e4e9992827a0 (recover uid if left off)

pw=74307d8442f54763ba6ffab7fdc9b610 (recover password if left off)

newpw=fbd9bf492bf149aeac3dc2a5bdcc38b2 (option. Change password if include.)

email=Billy@Hotsplt.com (recover email if left off)

newmail=Billy@Protonmail.com (optional. Change email if included)


Note: If the account has already been created the API just says success. 
Response if success:
```
{
	"server": "www.myBank.com",
	"status": "added",
	"message": "Account was created for user e24b3a755916472f8768e4e9992827a0. Username and Password sent to email provided.",
	"time": "2016-40-21 10:40:PM"
}
```

Response if fail:
```
{
	"server": "www.myBank.com",
	"status": "notadded",
	"message": "Account was not created for user e24b3a755916472f8768e4e9992827a0.",
	"time": "2016-40-21 10:40:PM"
}
```




# END OF CLOUDBANK VERSION 1




# ADVANCED SERVICE THAT ARE PROPOSED





# FOLDER STRUCTURE




Folder Structure
<pre>
UserAccounID
-Bank
-Broke
-Counterfeit
-Export
-Fracked
-Import
-Imported
-Logs
-Lost
-Suspect
-Templates
-Trash
-Waiting
</pre>



# ##################
## Change_Owner Account Service :
# ##################
Requests that a CloudCoin note change ownership from one account to another.

*CHANGE REQUEST STRING*

https://cloudcoin.global/bank/change_owner.php?nn=1&sn=15489521&newid=273C9DFA8061407AB8102C0A4E872CA3


*CHANGE RESPONSE STRING*

if success
```javascript
{
    "server": "www.myBank.com",
	"status": "change",
	"message": "Change Complete",
	"time": "2016-40-21 10:40:PM"
}
```
if fail
```javascript
{
    "server": "www.myBank.com",
	"status": "fail",
	"message": "Change Failed, No such account",
	"time": "2016-40-21 10:40:PM"
}
```



# ##################
## Change_Maker Service 
# ##################
Tells the Bank to break a CloudCoin note into several smaller notes.
Note that there are many (but a finte) way of making chage for each denomination. Each denomination will have a list (or matrix) of possible breaks with an id for Method for each possible method. 
 
*CHANGE_MAKER REQUEST STRING*

https://cloudcoin.global/bank/make_change.php?nn=1sn=88772322&method=100D

if good:

*CHANGE_MAKER RESPONSE STRING*
```javascript
{
	"server": "www.myBank.com",
	"status": "success",
	"nn":["1","1","1"],
	"sn":["5111558","9665542","1569855"],
	"message": "CloudCoin note was broken into smaller units.",
	"time": "2016-40-21 10:40:PM"
}
```
if bad:
```javascript
{
	"server": "www.myBank.com",
	"status": "fail",
	"nn":["1","1","1"],
	"sn":["5111558","9665542","1569855"],
	"message": "CloudCoin note was broken into smaller units.",
	"time": "2016-40-21 10:40:PM"
}

```

Make Change
*CHANGE_MAKER METHODS:*

Denominaton 1
+ 1 (Cannot break)

Denaomination 5
+ Method 5A: 1,1,1,1,1

Denomination 25
+ Method 25A: 5,5,5,5,5 (Min)
+ Method 25B: 5,5,5,5,5A
+ Method 25C: 5,5,5A,5A,5A
+ Method 25D: 5A,5A,5A,5A  (Max)

Denomination 100
+ Method 100A: 25,25,25,25 (min)
+ Method 100B: 25,25,25,25A
+ Method 100C: 25,25,25A,25B
+ Method 100D: 25D,25D,25D,25D (Max)


Denomination 250
+ Method 250A: 100,100,25,25 (Min)
+ Method 250B: 100A,100A,25A,25B
+ Method 250C: 100B,100B,25B,25C
+ Method 250D: 100D,100D,25D,25D (Max)



# ##################
## Issue Reference Service 
# ##################
The Issue Reference service issues a "check" that refers to a real cloudcoin in the bank. 
The purpose is to allow CloudCoins to circulate amoung the bank customers without having 
to authenticate with the RAIDA everytime they change hands instead they will authenticate 
with the bank.

CloudCoin check format:

Any file can store a CloudCoin check because the CloudCoin check is stored in the file name.
However, it is best to have a txt (text) file with a .check extension. The text file keep
he size of the file small.

Example of a CloudCoin check embedded in a file name:

```
250.CloudCoin.1.16777216.cb5e46ce270545b39b5efa9d9e199d93.www.myBank.com.2017.05.17.13.45.Any user memo here less 
than 155 characters.check
```

Denomination: For human reading.
CloudCoin: Litteral string for human reading
SN: Serial Number
NN: Network Number
AN: Single authenticity number (GUID with no hyphens) 
Bank Server URL: A DNS name or IP address of an application that can can turn the check into a 
real CloudCoin
Year:Year
Month
Day
Hour
Minute
Memo: 
Inside you can place a memo too. 


*ISSUE_REFERENCE REQUEST STRING*

https://cloudcoin.global/bank/issue_reference.php?nn=1&sn=88772322&method=1

*ISSUE_REFERENCE RESPONSE STRING*
```javascript
{
	"server": "www.myBank.com",
	"status": "success",
	"name":"250.CloudCoin.1.16777216.cb5e46ce270545b39b5efa9d9e199d93.www.myBank.com",
	"message": "CloudCoin note issued as reference.",
	"time": "2016-40-21 10:40:PM"
}
```
if bad:
```javascript
{
	"server": "www.myBank.com",
	"status": "fail",
	"name":"",
	"message": "CloudCoin not found. No reference can be made.",
	"time": "2016-40-21 10:40:PM"
}
```

# ##################
## Deposit Reference Service 
# ##################

*DEPOSIT_REFERENCE REQUEST STRING*

https://cloudcoin.global/bank/deposit_reference.php?an=cb5e46ce270545b39b5efa9d9e199d93

*DEPOSIT_REFERENCE RESPONSE STRING*
```javascript
{
	"server": "www.myBank.com",
	"status": "success",
	"name":"250.CloudCoin.1.16777216.cb5e46ce270545b39b5efa9d9e199d93.www.myBank.com",
	"message": "CloudCoin note issued as reference.",
	"time": "2016-40-21 10:40:PM"
}
```
if bad:
```javascript
{
	"server": "www.myBank.com",
	"status": "fail",
	"name":"",
	"message": "CloudCoin not found. No reference can be made.",
	"time": "2016-40-21 10:40:PM"
}
```

# ##################
## Service Detect Reference
# ##################

https://RAIDA20.cloudcoin.global/bank/detect_reference?nn=1&sn=16777216&an=1836843d928347fb22c2142b49d772b5&pan=1836843d928347fb22c2142b49d772b5

*Detection Response Example If Passed:*
```javascript
{
  "server":"www.myBank.com",
  "status":"pass",
  "sn":"16777216",
  "nn":"1",
  "message":"Authentic:16777216 is an authentic 1-unit. Your Proposed Authenticity Number is now the new Authenticate Number. Update your file.",
  "time":"2016-44-19 7:44:PM"
}
```
Note that the 1 after the word Authentic: is the serial number of the unit that was tested.
 
*Detection Response Example If failed to authenticate:*
```javascript
{
  "server":"www.myBank.com",
  "status":"fail",
  "sn":"16777216",
  "nn":"1",
  "message":"Counterfeit: The unit failed to authenticate on this server. You may need to fix it on other servers.",
  "time":"20"
}
```






END OF API





