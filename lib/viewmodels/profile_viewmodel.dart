class ProfileViewModel {
	// Validate non-empty display/name fields
	static String? validateDisplayName(String? value) {
		if (value == null || value.trim().isEmpty) return 'Tên không được để trống';
		return null;
	}

	// Generic non-empty validator (can be reused)
	static String? validateNonEmpty(String? value, String message) {
		if (value == null || value.trim().isEmpty) return message;
		return null;
	}

	// Email validation
	static String? validateEmail(String? value) {
		if (value == null || value.trim().isEmpty) return 'Email không được để trống';
		final emailReg = RegExp(r'^[\w\-.]+@[\w\-]+\.[a-zA-Z]{2,}');
		if (!emailReg.hasMatch(value)) return 'Email không hợp lệ';
		return null;
	}

	// DOB validation: dd/MM/yyyy
	static String? validateDob(String? value) {
		if (value == null || value.trim().isEmpty) return 'Ngày sinh không được để trống';
		final dReg = RegExp(r'^\d{2}/\d{2}/\d{4}\$');
		if (!dReg.hasMatch(value)) return 'Định dạng ngày sinh: dd/MM/yyyy';
		return null;
	}

	// URL validation (requires scheme http/https)
	static String? validateUrl(String? value) {
		if (value == null || value.trim().isEmpty) return null;
		final uri = Uri.tryParse(value);
		if (uri == null || (!uri.hasScheme)) return 'Nhập URL hợp lệ (bao gồm http/https)';
		return null;
	}

	// Password validators
	static String? validateCurrentPassword(String? value) {
		if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu hiện tại';
		return null;
	}

	static String? validatePassword(String? value) {
		if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu mới';
		if (value.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
		return null;
	}

	static String? validateConfirmPassword(String? confirm, String next) {
		if (confirm == null || confirm.isEmpty) return 'Vui lòng xác nhận mật khẩu';
		if (confirm != next) return 'Mật khẩu xác nhận không khớp';
		return null;
	}
}

