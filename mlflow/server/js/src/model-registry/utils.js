/**
 * Get a unique key for a model version object.
 * @param modelName
 * @param version
 * @returns {string}
 */
export const getModelVersionKey = (modelName, version) => `${modelName}_${version}`;

export const getProtoField = (fieldName) => `${fieldName}`;

export const checkDeploymentStatus = (modelId, deploymentUrl, inferenceApi, callback) => {
    var xhr = new XMLHttpRequest()
    console.log(modelId)
    xhr.addEventListener('load', () => {
        if (xhr.responseText =="deployed"){
            callback(true,inferenceApi+'/'+modelId)
        }
        else{
            callback(false,"Not Deployed")
        }
    });
    xhr.onerror = function (e) {
        callback(false,"Server not reachable");
    };
    xhr.open('GET', deploymentUrl + "?runId=" + modelId)
    xhr.send()
}

export const sendDeploymentRequest = (action, deploymentUrl, modelInfo, callback) => {
    modelInfo['action'] = action;
    var xhr = new XMLHttpRequest()
    xhr.addEventListener('load', () => {
        console.log(xhr.responseText);
    })
    // catch error
    xhr.onerror = function (e) {
        callback(false,"Server not reachable");
    };
    // send the request
    xhr.open('POST', deploymentUrl)
    xhr.send(JSON.stringify(modelInfo))
}
