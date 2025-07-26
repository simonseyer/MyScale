# Source: https://github.com/lolouk44/xiaomi_mi_scale

class bodyScales:
    def __init__(self, age, height, sex, weight, scaleType='xiaomi'):
        self.age = age
        self.height = height
        self.sex = sex
        self.weight = weight

        if scaleType == 'xiaomi':
            self.scaleType = 'xiaomi'
        else:
            self.scaleType = 'holtek'

    # Get BMI scale
    def getBMIScale(self):
        if self.scaleType == 'xiaomi':
            # Amazfit/new mi fit
            #return [18.5, 24, 28]
            # Old mi fit // amazfit for body figure
            return [18.5, 25.0, 28.0, 32.0]
        elif self.scaleType == 'holtek':
            return [18.5, 25.0, 30.0]

    # Get fat percentage scale
    def getFatPercentageScale(self):
        # The included tables where quite strange, maybe bogus, replaced them with better ones...
        if self.scaleType == 'xiaomi':
            scales = [
                {'min': 0, 'max': 12, 'female': [12.0, 21.0, 30.0, 34.0], 'male': [7.0, 16.0, 25.0, 30.0]},
                {'min': 12, 'max': 14, 'female': [15.0, 24.0, 33.0, 37.0], 'male': [7.0, 16.0, 25.0, 30.0]},
                {'min': 14, 'max': 16, 'female': [18.0, 27.0, 36.0, 40.0], 'male': [7.0, 16.0, 25.0, 30.0]},
                {'min': 16, 'max': 18, 'female': [20.0, 28.0, 37.0, 41.0], 'male': [7.0, 16.0, 25.0, 30.0]},
                {'min': 18, 'max': 40, 'female': [21.0, 28.0, 35.0, 40.0], 'male': [11.0, 17.0, 22.0, 27.0]},
                {'min': 40, 'max': 60, 'female': [22.0, 29.0, 36.0, 41.0], 'male': [12.0, 18.0, 23.0, 28.0]},
                {'min': 60, 'max': 100, 'female': [23.0, 30.0, 37.0, 42.0], 'male': [14.0, 20.0, 25.0, 30.0]},
            ]

        elif self.scaleType == 'holtek':
            scales = [
                {'min': 0, 'max': 21, 'female': [18, 23, 30, 35], 'male': [8, 14, 21, 25]},
                {'min': 21, 'max': 26, 'female': [19, 24, 30, 35], 'male': [10, 15, 22, 26]},
                {'min': 26, 'max': 31, 'female': [20, 25, 31, 36], 'male': [11, 16, 21, 27]},
                {'min': 31, 'max': 36, 'female': [21, 26, 33, 36], 'male': [13, 17, 25, 28]},
                {'min': 36, 'max': 41, 'female': [22, 27, 34, 37], 'male': [15, 20, 26, 29]},
                {'min': 41, 'max': 46, 'female': [23, 28, 35, 38], 'male': [16, 22, 27, 30]},
                {'min': 46, 'max': 51, 'female': [24, 30, 36, 38], 'male': [17, 23, 29, 31]},
                {'min': 51, 'max': 56, 'female': [26, 31, 36, 39], 'male': [19, 25, 30, 33]},
                {'min': 56, 'max': 100, 'female': [27, 32, 37, 40], 'male': [21, 26, 31, 34]},
            ]

        for scale in scales:
            if self.age >= scale['min'] and self.age < scale['max']:
                return scale[self.sex]

    # Get muscle mass scale
    def getMuscleMassScale(self):
        if self.scaleType == 'xiaomi':
            scales = [
                {'min': {'male': 170, 'female': 160}, 'female': [36.5, 42.6], 'male': [49.4, 59.5]},
                {'min': {'male': 160, 'female': 150}, 'female': [32.9, 37.6], 'male': [44.0, 52.5]},
                {'min': {'male': 0, 'female': 0}, 'female': [29.1, 34.8], 'male': [38.5, 46.6]},
            ]
        elif self.scaleType == 'holtek':
            scales = [
                {'min': {'male': 170, 'female': 170}, 'female': [36.5, 42.5], 'male': [49.5, 59.4]},
                {'min': {'male': 160, 'female': 160}, 'female': [32.9, 37.5], 'male': [44.0, 52.4]},
                {'min': {'male': 0, 'female': 0}, 'female': [29.1, 34.7], 'male': [38.5, 46.5]}
            ]

        for scale in scales:
            if self.height >= scale['min'][self.sex]:
                return scale[self.sex]



    # Get water percentage scale
    def getWaterPercentageScale(self):
        if self.scaleType == 'xiaomi':
            if self.sex == 'male':
                return [55.0, 65.1]
            elif self.sex == 'female':
                return [45.0, 60.1]
        elif self.scaleType == 'holtek':
            return [53, 67]


    # Get visceral fat scale
    def getVisceralFatScale(self):
        # Actually the same in mi fit/amazfit and holtek's sdk
        return [10.0, 15.0]


    # Get bone mass scale
    def getBoneMassScale(self):
        if self.scaleType == 'xiaomi':
            scales = [
                {'male': {'min': 75.0, 'scale': [2.0, 4.2]}, 'female': {'min': 60.0, 'scale': [1.8, 3.9]}},
                {'male': {'min': 60.0, 'scale': [1.9, 4.1]}, 'female': {'min': 45.0, 'scale': [1.5, 3.8]}},
                {'male': {'min': 0.0, 'scale': [1.6, 3.9]}, 'female': {'min': 0.0, 'scale': [1.3, 3.6]}},
            ]

            for scale in scales:
                if self.weight >= scale[self.sex]['min']:
                    return scale[self.sex]['scale']

        elif self.scaleType == 'holtek':
            scales = [
                {'female': {'min': 60, 'optimal': 2.5}, 'male': {'min': 75, 'optimal': 3.2}},
                {'female': {'min': 45, 'optimal': 2.2}, 'male': {'min': 69, 'optimal': 2.9}},
                {'female': {'min': 0, 'optimal': 1.8}, 'male': {'min': 0, 'optimal': 2.5}}
            ]

            for scale in scales:
                if self.weight >= scale[self.sex]['min']:
                    return [scale[self.sex]['optimal']-1, scale[self.sex]['optimal']+1]


    # Get BMR scale
    def getBMRScale(self):
        if self.scaleType == 'xiaomi':
            coefficients = {
                'male': {30: 21.6, 50: 20.07, 100: 19.35},
                'female': {30: 21.24, 50: 19.53, 100: 18.63}
            }
        elif self.scaleType == 'holtek':
            coefficients = {
                'female': {12: 34, 15: 29, 17: 24, 29: 22, 50: 20, 120: 19},
                'male': {12: 36, 15: 30, 17: 26, 29: 23, 50: 21, 120: 20}
            }

        for age, coefficient in coefficients[self.sex].items():
            if self.age < age:
                return [self.weight * coefficient]


    # Get protein scale (hardcoded in mi fit)
    def getProteinPercentageScale(self):
        # Actually the same in mi fit and holtek's sdk
        return [16, 20]

    # Get ideal weight scale (BMI scale converted to weights)
    def getIdealWeightScale(self):
        scale = []
        for bmiScale in self.getBMIScale():
            scale.append((bmiScale*self.height)*self.height/10000)
        return scale

    # Get Body Score scale
    def getBodyScoreScale(self):
        # very bad, bad, normal, good, better
        return [50.0, 60.0, 80.0, 90.0]

    # Return body type scale
    def getBodyTypeScale(self):
        return ['obese', 'overweight', 'thick-set', 'lack-exerscise', 'balanced', 'balanced-muscular', 'skinny', 'balanced-skinny', 'skinny-muscular']


# Reverse engineered from amazfit's app (also known as Mi Fit)
class bodyScore:

    def __init__(self, age, sex, height, weight, bmi, bodyfat, muscle, water, visceral_fat, bone, basal_metabolism, protein):
        self.age = age
        self.sex = sex
        self.height = height
        self.weight = weight
        self.bmi = bmi
        self.bodyfat = bodyfat
        self.muscle = muscle
        self.water = water
        self.visceral_fat = visceral_fat
        self.bone = bone
        self.basal_metabolism = basal_metabolism
        self.protein = protein
        self.scales = bodyScales(age, height, sex, weight)

    def getBodyScore(self):
        score = 100
        score -= self.getBmiDeductScore()
        score -= self.getBodyFatDeductScore()
        score -= self.getMuscleDeductScore()
        score -= self.getWaterDeductScore()
        score -= self.getVisceralFatDeductScore()
        score -= self.getBoneDeductScore()
        score -= self.getBasalMetabolismDeductScore()
        if self.protein:
            score -= self.getProteinDeductScore()
        return score

    def getMalus(self, data, min_data, max_data, max_malus, min_malus):
        result = ((data - max_data) / (min_data - max_data)) * float(max_malus - min_malus)
        if result >= 0.0:
            return result
        return 0.0

    def getBmiDeductScore(self):
        if not self.height >= 90:
            # "BMI is not reasonable
            return 0.0

        bmi_low = 15.0
        bmi_verylow = 14.0
        bmi_normal = 18.5
        bmi_overweight = 28.0
        bmi_obese = 32.0
        fat_scale = self.scales.getFatPercentageScale()

        # Perfect range (bmi >= 18.5 and bodyfat not high for adults, bmi >= 15.0 for kids
        if self.bmi >= 18.5 and self.age >= 18 and self.bodyfat < fat_scale[2]:
            return 0.0
        elif self.bmi >= bmi_verylow and self.age < 18 and self.bodyfat < fat_scale[2]:
            return 0.0

        # Extremely skinny (bmi < 14)
        elif self.bmi <= bmi_verylow:
            return 30.0
        # Too skinny (bmi between 14 and 15)
        elif self.bmi > bmi_verylow and self.bmi < bmi_low:
            return self.getMalus(self.bmi, bmi_verylow, bmi_low, 30, 15) + 15.0
        # Skinny (for adults, between 15 and 18.5)
        elif self.bmi >= bmi_low and self.bmi < bmi_normal and self.age >= 18:
            return self.getMalus(self.bmi, 15.0, 18.5, 15, 5) + 5.0

        # Normal or high bmi but too much bodyfat
        elif ((self.bmi >= bmi_low and self.age < 18) or (self.bmi >= bmi_normal and self.age >= 18)) and self.bodyfat >= fat_scale[2]:
            # Obese
            if self.bmi >= bmi_obese:
                return 10.0
            # Overweight
            if self.bmi > bmi_overweight:
                return self.getMalus(self.bmi, 28.0, 25.0, 5, 10) + 5.0
            else:
                return 0.0

    def getBodyFatDeductScore(self):
        scale = self.scales.getFatPercentageScale()

        if self.sex == 'male':
            best = scale[2] - 3.0
        elif self.sex == 'female':
            best = scale[2] - 2.0

        # Slighly low in fat or low part or normal fat
        if self.bodyfat >= scale[0] and self.bodyfat < best:
            return 0.0
        elif self.bodyfat >= scale[3]:
            return 20.0
        else:
            # Sightly high body fat
            if self.bodyfat < scale[3]:
                return self.getMalus(self.bodyfat, scale[3], scale[2], 20, 10) + 10.0

            # High part of normal fat
            elif self.bodyfat <= scale[2]:
                return self.getMalus(self.bodyfat, scale[2], best, 3, 9) + 3.0

            # Very low in fat
            elif self.bodyfat < scale[0]:
                return self.getMalus(self.bodyfat, 1.0, scale[0], 3, 10) + 3.0


    def getMuscleDeductScore(self):
        scale = self.scales.getMuscleMassScale()

        # For some reason, there's code to return self.calculate(muscle, normal[0], normal[0]+2.0, 3, 5) + 3.0
        # if your muscle is between normal[0] and normal[0] + 2.0, but it's overwritten with 0.0 before return
        if self.muscle >= scale[0]:
            return 0.0
        elif self.muscle < (scale[0] - 5.0):
            return 10.0
        else:
            return self.getMalus(self.muscle, scale[0] - 5.0, scale[0], 10, 5) + 5.0

    # No malus = normal or good; maximum malus (10.0) = less than normal-5.0;
    # malus = between 5 and 10, on your water being between normal-5.0 and normal
    def getWaterDeductScore(self):
        scale = self.scales.getWaterPercentageScale()

        if self.water >= scale[0]:
            return 0.0
        elif self.water <= (scale[0] - 5.0):
            return 10.0
        else:
            return self.getMalus(self.water, scale[0] - 5.0, scale[0], 10, 5) + 5.0

    # No malus = normal; maximum malus (15.0) = very high; malus = between 10 and 15
    # with your visceral fat in your high range
    def getVisceralFatDeductScore(self):
        scale = self.scales.getVisceralFatScale()

        if self.visceral_fat < scale[0]:
            # For some reason, the original app would try to
            # return 3.0 if vfat == 8 and 5.0 if vfat == 9
            # but i's overwritten with 0.0 anyway before return
            return 0.0
        elif self.visceral_fat >= scale[1]:
            return 15.0
        else:
            return self.getMalus(self.visceral_fat, scale[1], scale[0], 15, 10) + 10.0

    def getBoneDeductScore(self):
        scale = self.scales.getBoneMassScale()

        if self.bone >= scale[0]:
            return 0.0
        elif self.bone <= (scale[0] - 0.3):
            return 10.0
        else:
            return self.getMalus(self.bone, scale[0] - 0.3, scale[0], 10, 5) + 5.0

    def getBasalMetabolismDeductScore(self):
        # Get normal BMR
        normal = self.scales.getBMRScale()[0]

        if self.basal_metabolism >= normal:
            return 0.0
        elif self.basal_metabolism <= (normal - 300):
            return 6.0
        else:
            # It's really + 5.0 in the app, but it's probably a mistake, should be 3.0
            return self.getMalus(self.basal_metabolism, normal - 300, normal, 6, 3) + 5.0


    # Get protein percentage malus
    def getProteinDeductScore(self):
        # low: 10,16; normal: 16,17
        # Check limits
        if self.protein > 17.0:
            return 0.0
        elif self.protein < 10.0:
            return 10.0
        else:
            # Return values for low proteins or normal proteins
            if self.protein <= 16.0:
                return self.getMalus(self.protein, 10.0, 16.0, 10, 5) + 5.0
            elif self.protein <= 17.0:
                return self.getMalus(self.protein, 16.0, 17.0, 5, 3) + 3.0

class bodyMetrics:
    def __init__(self, weight, height, age, sex, impedance):
        self.weight = weight
        self.height = height
        self.age = age
        self.sex = sex
        self.impedance = impedance
        self.scales = bodyScales(age, height, sex, weight)

        # Check for potential out of boundaries
        if self.height > 220:
            print("Height is too high (limit: >220cm) or scale is sleeping")
            sys.stderr.write('Height is over 220cm\n')
            exit()
        elif weight < 10 or weight > 200:
            print("Weight is either too low or too high (limits: <10kg and >200kg)")
            sys.stderr.write('Weight is below 10kg or above 200kg\n')
            exit()
        elif age > 99:
            print("Age is too high (limit >99 years)")
            sys.stderr.write('Age is above 99 years\n')
            exit()
        elif impedance > 3000:
            print("Impedance is above 3000 Ohm")
            sys.stderr.write('Impedance is above 3000 Ohm\n')
            exit()

    # Set the value to a boundary if it overflows
    def checkValueOverflow(self, value, minimum, maximum):
        if value < minimum:
            return minimum
        elif value > maximum:
            return maximum
        else:
            return value

    # Get LBM coefficient (with impedance)
    def getLBMCoefficient(self):
        lbm =  (self.height * 9.058 / 100) * (self.height / 100)
        lbm += self.weight * 0.32 + 12.226
        lbm -= self.impedance * 0.0068
        lbm -= self.age * 0.0542
        return lbm

    # Get BMR
    def getBMR(self):
        if self.sex == 'female':
            bmr = 864.6 + self.weight * 10.2036
            bmr -= self.height * 0.39336
            bmr -= self.age * 6.204
        else:
            bmr = 877.8 + self.weight * 14.916
            bmr -= self.height * 0.726
            bmr -= self.age * 8.976

        # Capping
        if self.sex == 'female' and bmr > 2996:
            bmr = 5000
        elif self.sex == 'male' and bmr > 2322:
            bmr = 5000
        return self.checkValueOverflow(bmr, 500, 10000)

    # Get fat percentage
    def getFatPercentage(self):
        # Set a constant to remove from LBM
        if self.sex == 'female' and self.age <= 49:
            const = 9.25
        elif self.sex == 'female' and self.age > 49:
            const = 7.25
        else:
            const = 0.8

        # Calculate body fat percentage
        LBM = self.getLBMCoefficient()

        if self.sex == 'male' and self.weight < 61:
            coefficient = 0.98
        elif self.sex == 'female' and self.weight > 60:
            coefficient = 0.96
            if self.height > 160:
                coefficient *= 1.03
        elif self.sex == 'female' and self.weight < 50:
            coefficient = 1.02
            if self.height > 160:
                coefficient *= 1.03
        else:
            coefficient = 1.0
        fatPercentage = (1.0 - (((LBM - const) * coefficient) / self.weight)) * 100

        # Capping body fat percentage
        if fatPercentage > 63:
            fatPercentage = 75
        return self.checkValueOverflow(fatPercentage, 5, 75)

    # Get water percentage
    def getWaterPercentage(self):
        waterPercentage = (100 - self.getFatPercentage()) * 0.7

        if (waterPercentage <= 50):
            coefficient = 1.02
        else:
            coefficient = 0.98

        # Capping water percentage
        if waterPercentage * coefficient >= 65:
            waterPercentage = 75
        return self.checkValueOverflow(waterPercentage * coefficient, 35, 75)

    # Get bone mass
    def getBoneMass(self):
        if self.sex == 'female':
            base = 0.245691014
        else:
            base = 0.18016894

        boneMass = (base - (self.getLBMCoefficient() * 0.05158)) * -1

        if boneMass > 2.2:
            boneMass += 0.1
        else:
            boneMass -= 0.1

        # Capping boneMass
        if self.sex == 'female' and boneMass > 5.1:
            boneMass = 8
        elif self.sex == 'male' and boneMass > 5.2:
            boneMass = 8
        return self.checkValueOverflow(boneMass, 0.5 , 8)

    # Get muscle mass
    def getMuscleMass(self):
        muscleMass = self.weight - ((self.getFatPercentage() * 0.01) * self.weight) - self.getBoneMass()

        # Capping muscle mass
        if self.sex == 'female' and muscleMass >= 84:
            muscleMass = 120
        elif self.sex == 'male' and muscleMass >= 93.5:
            muscleMass = 120

        return self.checkValueOverflow(muscleMass, 10 ,120)

    # Get Visceral Fat
    def getVisceralFat(self):
        if self.sex == 'female':
            if self.weight > (13 - (self.height * 0.5)) * -1:
                subsubcalc = ((self.height * 1.45) + (self.height * 0.1158) * self.height) - 120
                subcalc = self.weight * 500 / subsubcalc
                vfal = (subcalc - 6) + (self.age * 0.07)
            else:
                subcalc = 0.691 + (self.height * -0.0024) + (self.height * -0.0024)
                vfal = (((self.height * 0.027) - (subcalc * self.weight)) * -1) + (self.age * 0.07) - self.age
        else:
            if self.height < self.weight * 1.6:
                subcalc = ((self.height * 0.4) - (self.height * (self.height * 0.0826))) * -1
                vfal = ((self.weight * 305) / (subcalc + 48)) - 2.9 + (self.age * 0.15)
            else:
                subcalc = 0.765 + self.height * -0.0015
                vfal = (((self.height * 0.143) - (self.weight * subcalc)) * -1) + (self.age * 0.15) - 5.0

        return self.checkValueOverflow(vfal, 1 ,50)

    # Get BMI
    def getBMI(self):
        return self.checkValueOverflow(self.weight/((self.height/100)*(self.height/100)), 10, 90)

    # Get ideal weight (just doing a reverse BMI, should be something better)
    def getIdealWeight(self, orig=True):
        # Uses mi fit algorithm (or holtek's one)
        if orig and self.sex == 'female':
            return (self.height - 70) * 0.6
        elif orig and self.sex == 'male':
            return (self.height - 80) * 0.7
        else:
            return self.checkValueOverflow((22*self.height)*self.height/10000, 5.5, 198)

    # Get fat mass to ideal (guessing mi fit formula)
    def getFatMassToIdeal(self):
        mass = (self.weight * (self.getFatPercentage() / 100)) - (self.weight * (self.scales.getFatPercentageScale()[2] / 100))
        if mass < 0:
            return {'type': 'to_gain', 'mass': mass*-1}
        else:
            return {'type': 'to_lose', 'mass': mass}

    # Get protetin percentage (warn: guessed formula)
    def getProteinPercentage(self, orig=True):
        # Use original algorithm from mi fit (or legacy guess one)
        if orig:
            proteinPercentage = (self.getMuscleMass() / self.weight) * 100
            proteinPercentage -= self.getWaterPercentage()
        else:
            proteinPercentage = 100 - (floor(self.getFatPercentage() * 100) / 100)
            proteinPercentage -= floor(self.getWaterPercentage() * 100) / 100
            proteinPercentage -= floor((self.getBoneMass()/self.weight*100) * 100) / 100

        return self.checkValueOverflow(proteinPercentage, 5, 32)

    # Get body type (out of nine possible)
    def getBodyType(self):
        if self.getFatPercentage() > self.scales.getFatPercentageScale()[2]:
            factor = 0
        elif self.getFatPercentage() < self.scales.getFatPercentageScale()[1]:
            factor = 2
        else:
            factor = 1

        if self.getMuscleMass() > self.scales.getMuscleMassScale()[1]:
            return 2 + (factor * 3)
        elif self.getMuscleMass() < self.scales.getMuscleMassScale()[0]:
            return (factor * 3)
        else:
            return 1 + (factor * 3)

    # Get Metabolic Age
    def getMetabolicAge(self):
        if self.sex == 'female':
            metabolicAge = (self.height * -1.1165) + (self.weight * 1.5784) + (self.age * 0.4615) + (self.impedance * 0.0415) + 83.2548
        else:
            metabolicAge = (self.height * -0.7471) + (self.weight * 0.9161) + (self.age * 0.4184) + (self.impedance * 0.0517) + 54.2267
        return self.checkValueOverflow(metabolicAge, 15, 80)


simon = bodyMetrics(66, 183, 30, 'male', 565)
print("bmi", simon.getBMI()) # HealthKit
print("fat", simon.getFatPercentage()) # HealthKit
print("water", simon.getWaterPercentage())
print("muscle", simon.getMuscleMass()) # off
print("bone", simon.getBoneMass()) # off
print("bmr", simon.getBMR())
print("visceral fat", simon.getVisceralFat())
print("lbm", simon.getLBMCoefficient()) # HealthKit
print("lean body mass (KG)", simon.getLBMCoefficient() * 66 / 100) # HealthKit
