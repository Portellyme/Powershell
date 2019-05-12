


#Convert to Epoch 
$UnixStartDate = [System.DateTime]::new(1970,1,1,0,0,0,[System.DateTimeKind]::Utc)
$Date = [System.DateTime]::new(2015,11,20,15,30,00)

# Convert Date to UTC
$DateUtc = $Date.ToUniversalTime()
# Get Ticks
$Ticks = $DateUtc.Ticks - $UnixStartDate.Ticks
# Convert Ticks to Timespan
$EpochTimeSpan = $Ticks / [System.TimeSpan]::TicksPerSecond
# Return EpochTimeSpan

#Convert From Epoch 
$EpochInTicks = $EpochTimeSpan * [System.TimeSpan]::TicksPerSecond
# Add Ticks to Unix Start Date in UTC
$UtcDate = $UnixStartDate.AddTicks($EpochInTicks)
#Convert in Local Time
$LocalDate = $Utc.ToLocalTime()
# Return LocalDate

#ADD UFormat possibility 
<#ptions available for uFormat values:

Date:
D    Date in mm/dd/yy format (06/14/06)
x    Date in standard format for locale (09/12/07 for English-US)

Year:
C   Century (20 for 2006)
Y   Year in 4-digit format (2006)
y   Year in 2-digit format (06)
G   Same as ‘Y’
g   Same as ‘y’

Month:
b   Month name – abbreviated (Jan)
B   Month name – full (January)
h   Same as ‘b’
m   Month number (06)

Week:
W  Week of the year (00-52)
V   Week of the year (01-53)
U   Same as ‘W’

Day:
a   Day of the week – abbreviated name (Mon)
A   Day of the week – full name (Monday)
u   Day of the week – number (Monday = 1)
d   Day of the month – 2 digits (05)
e   Day of the month – digit preceded by a space ( 5)
j    Day of the year – (1-366)
w   Same as ‘u’

Time:
p   AM or PM
r   Time in 12-hour format (09:15:36 AM)
R   Time in 24-hour format – no seconds (17:45)
T   Time in 24 hour format (17:45:52)
X   Same as ‘T’
Z   Time zone offset from Universal Time Coordinate (UTC) (-07)

Hour:
H   Hour in 24-hour format (17)
I    Hour in 12 hour format (05)
k   Same as ‘H’
l    Same as ‘I’ (Upper-case I = Lower-case L)

Minutes & Seconds:
M   Minutes (35)
S   Seconds (05)
s   Seconds elapsed since January 1, 1970 00:00:00 (1150451174.95705)

#>
