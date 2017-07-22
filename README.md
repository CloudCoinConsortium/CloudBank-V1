# Server Side CloudCoin Banking Software
*PROPOSED CLOUDCOIN BANK API 7/10/2017*

This code allows your server or application to pown (password own) CloudCoins and track those CloudCoins owned by your users.
You can also issue "checks" that refer to your CloudCoins so that users/customers who use your bank can trade amoung themselves
without needing to detect counterfeits everytime with the RAIDA. 


# ###################
## Service Import
# ##################
To send CloudCoins to the bank, your program must first put the CloudCoin stack file in the import folder. Then it must call the Bank's import service to import.

There is a naming convention for programs to use to put the coins in the import folder:
File Name Format:
```
1.12720.cloudcoin.273C9DFA8061407AB8102C0A4E872CA3.stack
```
Where 1 is the network number

Where 12720 = Total amount of CloudCoins in the stack file.

Where 273C9DFA8061407AB8102C0A4E872CA3 = Account ID of the user or entity that the CloudCoins belong to. 


*IMPORT REQUEST STRING*

To pown all the files in the mort folder

https://cloudcoin.global/bank/import.php?id=all

To pown all the files in the import folder that belong to one account:

https://cloudcoin.global/bank/import.php?id=273C9DFA8061407AB8102C0A4E872CA3


*IMPORT RESPONSE STRING*

Response if success:
```javascript
{
	"server": "www.myBank.com",
	"status": "import",
	"cloudcoins": [{
		"sn": "152485046",
		"nn": "1",
		"results": "counterfeit"
	}, {
		"sn": "152485045",
		"nn": "1",
		"results": "authentic"
	}],
	"message": "Import Complete",
	"time": "2016-40-21 10:40:PM"
}
```
Or Response if Failed
```javascript
{
	"server": "www.myBank.com",
	"status": "empty",
	"cloudcoins": [],
	"message": "The Import folder was empty",
	"time": "2016-40-21 10:40:PM"
}
```
# ##################
## Service Change_Owner Account:
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
# Service Export
# ##################
Exports the coins from the bank folder to the export folder/email so they can be downloaded or emailed.

*EXPORT REQUEST STRING*

https://cloudcoin.global/bank/export.php?sn=15489521&tag=273C9DFA8061407AB8102C0A4E872CA3

*EXPORT RESPONSE STRING*

Response if good:
```javascript
{
	"server": "www.myBank.com",
	"status": "export",
	"message": "Export Complete",
	"time": "2016-40-21 10:40:PM"
}
```
Response if bad:
```javascript
{
	"server": "www.myBank.com",
	"status": "fail",
	"message": "Coin did not exist",
	"time": "2016-40-21 10:40:PM"
}
```


# ##################
## Service ShowCoins
# ##################
Lets the program know how many coins the user has in the bank. Or how many coins are in the bank total.

*SHOWCOINS REQUEST STRING*

https://cloudcoin.global/bank/showcoins.php?id=all

(Shows all the coins that belong to account id 273C9DFA8061407AB8102C0A4E872CA3)

https://cloudcoin.global/bank/showcoins.php?id=273C9DFA8061407AB8102C0A4E872CA3

(Shows all the coins in the bank)


*SHOWCOINS RESPONSE STRING*

if good:
```javascript
{
	"server": "www.myBank.com",
	"status": "showcoins",
	"sn":["5111558","9665542","1569855"],
	"total":"1242",
	"message": "273C9DFA8061407AB8102C0A4E872CA3 has 1242 CloudCoins",
	"time": "2016-40-21 10:40:PM"
}
```
if bad:
```javascript
{
	"server": "www.myBank.com",
	"status": "fail",
	"sn":["5111558","9665542","1569855"],
	"total":"0",
	"message": "Account did not exist",
	"time": "2016-40-21 10:40:PM"
}

```


# ##################
## Service Change_Maker
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
## Service Issue Reference
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

```javascript
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
## Service Deposit Reference
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

https://RAIDA20.cloudcoin.global/bank/detect_reference?nn=1&sn=1&an=1836843d928347fb22c2142b49d772b5&pan=1836843d928347fb22c2142b49d772b5

*Detection Response Example If Passed:*
```javascript
{
  "server":"www.myBank.com",
  "status":"pass",
  "sn":"1",
  "nn":"1",
  "message":"Authentic:1 is an authentic 1-unit. Your Proposed Authenticity Number is now the new Authenticate Number. Update your file.",
  "time":"2016-44-19 7:44:PM"
}
```
Note that the 1 after the word Authentic: is the serial number of the unit that was tested.
 
*Detection Response Example If failed to authenticate:*
```javascript
{
  "server":"www.myBank.com",
  "status":"fail",
  "sn":"1",
  "nn":"1",
  "message":"Counterfeit: The unit failed to authenticate on this server. You may need to fix it on other servers.",
  "time":"20
}
```






END OF API



