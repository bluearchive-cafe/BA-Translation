if (typeof Il2Cpp === 'undefined') {
    return;
}

Il2Cpp.perform(function () {
    const targetClass = 'MX.NetworkProtocol.QueuingGetCryptoKeysResponse';
    
    const setKeyMethod = Il2Cpp.Api.get_method_pointer(targetClass + '::set_EncryptedSqlCipherKey');
    const setLicenseMethod = Il2Cpp.Api.get_method_pointer(targetClass + '::set_EncryptedSqlCipherLicense');

    if (setKeyMethod) {
        Interceptor.attach(setKeyMethod, {
            onEnter: function (args) {
                try {
                    const key_value = Il2Cpp.String.from(args[1]).toString();
                    console.log("[RESULT] EncryptedSqlCipherKey: " + key_value);
                } catch (e) {
                    console.log("[ERROR] Cannot read EncryptedSqlCipherKey string: " + e);
                }
            }
        });
        console.log("Hooked set_EncryptedSqlCipherKey at " + setKeyMethod);
    } else {
        console.log("Method set_EncryptedSqlCipherKey not found!");
    }

    if (setLicenseMethod) {
        Interceptor.attach(setLicenseMethod, {
            onEnter: function (args) {
                try {
                    const license_value = Il2Cpp.String.from(args[1]).toString();
                    console.log("[RESULT] EncryptedSqlCipherLicense: " + license_value);
                } catch (e) {
                    console.log("[ERROR] Cannot read EncryptedSqlCipherLicense string: " + e);
                }
            }
        });
        console.log("Hooked set_EncryptedSqlCipherLicense at " + setLicenseMethod);
    } else {
        console.log("Method set_EncryptedSqlCipherLicense not found!");
    }
});
