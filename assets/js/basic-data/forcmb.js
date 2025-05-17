function getHospitalsForCMBAsync(required, callBack) {
    const defaultOption = '<option value="0">انتخاب بیمارستان</option>';
    ajaxGet('/BasicData/Hospitals', function (hospitals) {
        let hospitalOptions = hospitals.map(hospital =>
            `<option value='${hospital.id}'>${hospital.title}</option>`
        ).join('');
        if (!required)
            hospitalOptions = defaultOption + hospitalOptions;
        if (callBack)
            callBack(hospitalOptions);
    });
}
function fillHospitalsCMBAsync(cmbId, required) {
   getHospitalsForCMBAsync(required, function (html) {
       $('#' + cmbId).html(html);
    });
}
function getPhotoTopicsForCMBAsync(required, callBack) {
    const defaultOption = '<option value="0">انتخاب موضوع</option>';
    ajaxGet('/BasicData/PhotoTopics', function (items) {
        let options = items.map(item =>
            `<option value='${item.id}'>${item.title}</option>`
        ).join('');
        if (!required)
            options = defaultOption + options;
        if (callBack)
            callBack(options);
    });
}
function fillPhotoTopicsCMBAsync(cmbId, required, callBack) {
    getPhotoTopicsForCMBAsync(required, function (html) {
        $('#' + cmbId).html(html);
        if (callBack) {
            callBack();
        }
    });
}