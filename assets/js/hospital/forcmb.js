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