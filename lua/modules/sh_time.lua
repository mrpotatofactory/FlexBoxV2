-----------------------------------------------------
module("time", package.seeall)

function IsNew(createdTime)
	if createdTime == 0 then return false end
	local currentTime = os.time()
	local elapsed = os.difftime(currentTime - createdTime)
	local futureTime = (60 * 60) * 24 * 15 -- 15 days in the future

	return elapsed < futureTime
end

function IsChristmas()
	local date = os.date("*t")

	return date.day >= 20 and date.month == 12
end

function IsNewYears()
	local date = os.date("*t")

	return date.day >= 30 and date.month == 12
end

function IsHalloween()
	local date = os.date("*t")

	return (date.day >= 1 and date.month == 10) or (date.day >= 1 and date.day <= 20 and date.month == 11)
end

function IsIndepedenceDay()
	local date = os.date("*t")

	return date.day >= 2 and date.day <= 5 and date.month == 7
end

function IsThanksgiving()
	local date = os.date("*t")

	return date.day >= 20 and date.day <= 28 and date.month == 11
end