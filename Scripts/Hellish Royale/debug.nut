function MainClass::Debug(msg, lvl) {
	if (lvl == 0) {
		GSLog.Info("[MHHR] " + msg);
	} else {
		if (this.enable_debug && lvl > 0){
			if (msg != null) {
				GSLog.Info("[MHHR DEBUG] " + msg);
			} else {
				GSLog.Info("");
			}
		}
	}
}