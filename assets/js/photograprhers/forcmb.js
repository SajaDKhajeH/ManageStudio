function getPhotographersForCMBAsync(required, callBack) {
    const defaultOption = '<option value="0">انتخاب عکاس</option>';
    ajaxGet('/User/GetAllPhotographers', function (items) {
        let options = items.map(item =>
            `<option value='${item.id}'>${item.title}</option>`
        ).join('');
        if (!required)
            options = defaultOption + options;
        if (callBack)
            callBack(options);
    });
}
function fillPhotographersCMBAsync(cmbId, required, callBack) {
   getPhotographersForCMBAsync(required, function (html) {
       $('#' + cmbId).html(html);
       if (callBack) {
           callBack();
       }
    });
}