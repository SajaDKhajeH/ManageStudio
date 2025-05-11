function getHospitalsForCMBAsync(required, callBack) {
    const defaultOption = '<option value="0">انتخاب بیمارستان</option>';
    ajaxGet('/BasicData/Hospitals', function (hospitals) {
        let hospitalOptions = hospitals.map(hospital =>
            `<option value="${hospital.id}">${hospital.title}</option>`
        ).join('');
        if (!required)
            hospitalOptions = defaultOption + hospitalOptions;
        callBack(hospitalOptions);
    });
}
function fillHospitalsCMBAsync(cmbId, required, callBack) {
    const html = getHospitalsForCMBAsync(required, callBack);
    $('#' + cmbId).html(html);
}