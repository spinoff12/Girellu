function init_pure_script()
	__SCRIPT__setVersion(7.4)
	__SCRIPT__UI_SliderFloat("Contrast Day", 0.975, 0.96, 1.0)
	__SCRIPT__UI_SliderFloat("Gamma Day", 1.58, 1.4, 1.7)
	PURE__ExpCalc_set_Limits(.07,.5)
	PURE__use_SpectrumAdaption(true)
	PURE__use_VAOAdaption(true)
	PURE__ExpCalc_set_Target(1.26)
	__PURE__set_config("light.sky.level",0.92)
	ac.setGodraysGlareRatio(0.01)
	ac.setGodraysAngleAttenuation(12)
	ac.setGodraysCustomColor(rgb(3,3,3))
end

function update_pure_script(dt)
	curr_ae = PURE__ExpCalc_get_final_exposure()
	curve = sun_compensate(2) - 1
	gamma_day = __SCRIPT__UI_getValue("Gamma Day")
	contrast_day = __SCRIPT__UI_getValue("Contrast Day")
	PURE__ExpCalc_set_Sensitivity(1.5 + -1 * (from_twilight_compensate(0.5)))
    ac.setGodraysLength(__IntD(8,4,0.6) * PURE__getGodraysModulator())
	ac.setPpContrast(1 - ((1-contrast_day) * sun_compensate(0)))
	ac.setPpTonemapGamma(gamma_day - (0.18 * curve))
	ac.setPpBrightness(1 + (0.25 * curve))
	ac.setPpTonemapFilmicContrast(0.25 + (0.15 * night_compensate(0)))
	ac.setPpSaturation(-0.025 + day_compensate(1.025))
	ac.setGlareBloomLuminanceGamma(math.lerp(1.7,1.1,curr_ae*2))
	ac.debug("exp", string.format('%.3f', curr_ae))
end