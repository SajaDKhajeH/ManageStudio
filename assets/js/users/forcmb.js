function getPhotographersForCMBAsync(required, callBack) {
    const defaultOption = '<option value="">انتخاب عکاس</option>';
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

function getDesignersForCMBAsync(required, callBack) {
    const defaultOption = '<option value="">انتخاب طراح</option>';
    ajaxGet('/User/GetAllDesigners', function (items) {
        let options = items.map(item =>
            `<option value='${item.id}'>${item.title}</option>`
        ).join('');
        if (!required)
            options = defaultOption + options;
        if (callBack)
            callBack(options);
    });
}
function fillDesignersCMBAsync(cmbId, required, callBack) {
    getDesignersForCMBAsync(required, function (html) {
        $('#' + cmbId).html(html);
        if (callBack) {
            callBack();
        }
    });
}
function getInvoiceCreatorsForCMBAsync(required, callBack) {
    const defaultOption = '<option value="">انتخاب ثبت کننده</option>';
    ajaxGet('/User/GetInvoiceCreators', function (items) {
        let options = items.map(item =>
            `<option value='${item.id}'>${item.title}</option>`
        ).join('');
        if (!required)
            options = defaultOption + options;
        if (callBack)
            callBack(options);
    });
}
function fillInvoiceCreatorsCMBAsync(cmbId, required, callBack) {
    getInvoiceCreatorsForCMBAsync(required, function (html) {
        $('#' + cmbId).html(html);
        if (callBack) {
            callBack();
        }
    });
}