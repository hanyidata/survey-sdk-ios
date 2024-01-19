(self.webpackChunksurvey=self.webpackChunksurvey||[]).push([[759],{7439:function(t,e,n){"use strict";n.r(e),n.d(e,{default:function(){return a}});var r=n(6407),o=n(4587),i=(e=(n(8862),n(2222),n(9442)),n(2502)),a=(e={components:{"hy-survey":e.Z},data:function(){return{show:!0,surveyId:null,channelId:null,token:null,delay:1e3,surveyError:"",logger:window.console.log,survey:{},borderRadiusMode:null,parameters:{accessCode:111},closed:!1,options:{}}},computed:{style:function(){return this.survey.style}},created:function(){var t=this;return(0,o.Z)((0,r.Z)().mark((function e(){return(0,r.Z)().wrap((function(e){for(;;)switch(e.prev=e.next){case 0:console.debug("setup bridge"),document.addEventListener("init",t.handleInit),document.addEventListener("show",t.handleShow),document.addEventListener("close",t.handleClose),t.injectLog();case 5:case"end":return e.stop()}}),e)})))()},methods:{handleFocus:function(t){this._callNative("surveyProxy",JSON.stringify({type:"input-focus",question:t}))},handleBlur:function(t){console.debug("lost input focus"),this._callNative("surveyProxy",JSON.stringify({type:"input-blur",question:t}))},injectLog:function(){window.console.log=this.forwardLog,window.console.info=this.forwardLog,window.console.warn=this.forwardLog,window.console.debug=this.forwardLog,this._callNative("surveyProxy",JSON.stringify({type:"init",options:this.options}))},forwardLog:function(t){this._callNative("logger",t)},handleShow:function(t){console.debug("received show command"),this.show=!0},handleClose:function(t){console.debug("received close command")},handleInit:function(t){var e=t.detail||{},n=e.surveyId,r=e.channelId,o=e.token,a=e.delay,s=e.parameters,c=e.server;e=e.borderRadiusMode;this.borderRadiusMode=e,c&&(0,i.z)(null,{collectorMethod:"APP"},c),t.detail.halfscreen&&(this.options.halfscreen=!0),this.options.project=t.detail.project,n&&r?(this.delay=a||1e3,this.surveyId=n,this.channelId=r,this.token=o,this.parameters=s||{},this.closed=!1,console.debug("init survey surveyId:".concat(n,";  channelId:").concat(r,"; token:").concat(o," event.detail: ").concat(JSON.stringify(t.detail||{})))):console.warn("invalid command ".concat(JSON.stringify(t.detail||{})))},handleHide:function(t){this.show=!1,this.closed=!0,this._callNative("surveyProxy",JSON.stringify({type:"close",reason:t}))},handleCancel:function(){console.debug("cancel"),this.$refs.survey&&this.$refs.survey.distubUploadEve("CLOSE"),this.show=!1,this._callNative("surveyProxy",JSON.stringify({type:"cancel"}))},handleSubmit:function(){this._callNative("surveyProxy",JSON.stringify({type:"submit"}))},handleLoad:function(t){this._callNative("logger",JSON.stringify({type:"logger"})),this.survey=t,this._callNative("surveyProxy",JSON.stringify({type:"load",configure:t&&t.channel&&t.channel.configure,options:this.options}))},handleSize:function(t){this.closed||this._callNative("surveyProxy",JSON.stringify({type:"size",value:t}))},_callNative:function(t,e){window.webkit&&window.webkit.messageHandlers&&window.webkit.messageHandlers[t]?window.webkit.messageHandlers[t].postMessage(e):window[t]?window[t].postMessage(e):this.logger("".concat(t,": "),e)}}},(0,n(9453).Z)(e,(function(){var t=this,e=t.$createElement;e=t._self._c||e;return t.surveyId&&t.channelId?e("v-uni-view",{staticClass:"hy-survey-embed-index bridge",class:{"half-screen-bridge":t.options&&t.options.halfscreen}},[e("v-uni-view",{staticClass:"hy-wx-close",style:{color:t.style&&t.style.closeBtnColor?t.style.closeBtnColor:"#556976"},on:{click:function(e){arguments[0]=e=t.$handleEvent(e),t.handleCancel.apply(void 0,arguments)}}},[t._v("×")]),t.surveyId&&t.channelId||t.token?e("hy-survey",{ref:"survey",attrs:{borderRadiusMode:t.borderRadiusMode,delay:t.delay,resize:!0,show:t.show,surveyId:t.surveyId,channelId:t.channelId,token:t.token,options:t.options,parameters:t.parameters},on:{focus:function(e){arguments[0]=e=t.$handleEvent(e),t.handleFocus.apply(void 0,arguments)},blur:function(e){arguments[0]=e=t.$handleEvent(e),t.handleBlur.apply(void 0,arguments)},hide:function(e){arguments[0]=e=t.$handleEvent(e),t.handleHide.apply(void 0,arguments)},size:function(e){arguments[0]=e=t.$handleEvent(e),t.handleSize.apply(void 0,arguments)},submit:function(e){arguments[0]=e=t.$handleEvent(e),t.handleSubmit.apply(void 0,arguments)},load:function(e){arguments[0]=e=t.$handleEvent(e),t.handleLoad.apply(void 0,arguments)}}}):t._e()],1):t._e()}),[],!1,null,null,null,!1,void 0,void 0).exports)},2443:function(t,e,n){n(6800)("asyncIterator")},4587:function(t,e,n){"use strict";function r(t,e,n,r,o,i,a){try{var s=t[i](a),c=s.value}catch(t){return void n(t)}s.done?e(c):Promise.resolve(c).then(r,o)}function o(t){return function(){var e=this,n=arguments;return new Promise((function(o,i){var a=t.apply(e,n);function s(t){r(a,o,i,s,c,"next",t)}function c(t){r(a,o,i,s,c,"throw",t)}s(void 0)}))}}n.d(e,{Z:function(){return o}}),n(1539)},6407:function(t,e,n){"use strict";n.d(e,{Z:function(){return o}}),n(9070),n(2526),n(1817),n(1539),n(2165),n(8783),n(3948),n(2443),n(3680),n(3706),n(2703),n(489),n(1703),n(6647),n(7658),n(4747),n(8304),n(5069),n(7042);var r=n(6257);function o(){
/*! regenerator-runtime -- Copyright (c) 2014-present, Facebook, Inc. -- license (MIT): https://github.com/facebook/regenerator/blob/main/LICENSE */
o=function(){return t};var t={},e=Object.prototype,n=e.hasOwnProperty,i=Object.defineProperty||function(t,e,n){t[e]=n.value},a="function"==typeof Symbol?Symbol:{},s=a.iterator||"@@iterator",c=a.asyncIterator||"@@asyncIterator",l=a.toStringTag||"@@toStringTag";function u(t,e,n){return Object.defineProperty(t,e,{value:n,enumerable:!0,configurable:!0,writable:!0}),t[e]}try{u({},"")}catch(e){u=function(t,e,n){return t[e]=n}}function h(t,e,n,r){var o,a,s,c;e=e&&e.prototype instanceof y?e:y,e=Object.create(e.prototype),r=new E(r||[]);return i(e,"_invoke",{value:(o=t,a=n,s=r,c="suspendedStart",function(t,e){if("executing"===c)throw new Error("Generator is already running");if("completed"===c){if("throw"===t)throw e;return N()}for(s.method=t,s.arg=e;;){var n=s.delegate;if(n&&(n=function t(e,n){var r=n.method,o=e.iterator[r];return void 0===o?(n.delegate=null,"throw"===r&&e.iterator.return&&(n.method="return",n.arg=void 0,t(e,n),"throw"===n.method)||"return"!==r&&(n.method="throw",n.arg=new TypeError("The iterator does not provide a '"+r+"' method")),f):(r=d(o,e.iterator,n.arg),"throw"===r.type?(n.method="throw",n.arg=r.arg,n.delegate=null,f):(o=r.arg,o?o.done?(n[e.resultName]=o.value,n.next=e.nextLoc,"return"!==n.method&&(n.method="next",n.arg=void 0),n.delegate=null,f):o:(n.method="throw",n.arg=new TypeError("iterator result is not an object"),n.delegate=null,f)))}(n,s),n)){if(n===f)continue;return n}if("next"===s.method)s.sent=s._sent=s.arg;else if("throw"===s.method){if("suspendedStart"===c)throw c="completed",s.arg;s.dispatchException(s.arg)}else"return"===s.method&&s.abrupt("return",s.arg);if(c="executing",n=d(o,a,s),"normal"===n.type){if(c=s.done?"completed":"suspendedYield",n.arg===f)continue;return{value:n.arg,done:s.done}}"throw"===n.type&&(c="completed",s.method="throw",s.arg=n.arg)}})}),e}function d(t,e,n){try{return{type:"normal",arg:t.call(e,n)}}catch(t){return{type:"throw",arg:t}}}t.wrap=h;var f={};function y(){}function v(){}function p(){}a={};var g=(u(a,s,(function(){return this})),Object.getPrototypeOf),w=(g=g&&g(g(_([]))),g&&g!==e&&n.call(g,s)&&(a=g),p.prototype=y.prototype=Object.create(a));function m(t){["next","throw","return"].forEach((function(e){u(t,e,(function(t){return this._invoke(e,t)}))}))}function b(t,e){var o;i(this,"_invoke",{value:function(i,a){function s(){return new e((function(o,s){!function o(i,a,s,c){var l;i=d(t[i],t,a);if("throw"!==i.type)return(a=(l=i.arg).value)&&"object"==(0,r.Z)(a)&&n.call(a,"__await")?e.resolve(a.__await).then((function(t){o("next",t,s,c)}),(function(t){o("throw",t,s,c)})):e.resolve(a).then((function(t){l.value=t,s(l)}),(function(t){return o("throw",t,s,c)}));c(i.arg)}(i,a,o,s)}))}return o=o?o.then(s,s):s()}})}function L(t){var e={tryLoc:t[0]};1 in t&&(e.catchLoc=t[1]),2 in t&&(e.finallyLoc=t[2],e.afterLoc=t[3]),this.tryEntries.push(e)}function x(t){var e=t.completion||{};e.type="normal",delete e.arg,t.completion=e}function E(t){this.tryEntries=[{tryLoc:"root"}],t.forEach(L,this),this.reset(!0)}function _(t){if(t){var e,r=t[s];if(r)return r.call(t);if("function"==typeof t.next)return t;if(!isNaN(t.length))return e=-1,(r=function r(){for(;++e<t.length;)if(n.call(t,e))return r.value=t[e],r.done=!1,r;return r.value=void 0,r.done=!0,r}).next=r}return{next:N}}function N(){return{value:void 0,done:!0}}return i(w,"constructor",{value:v.prototype=p,configurable:!0}),i(p,"constructor",{value:v,configurable:!0}),v.displayName=u(p,l,"GeneratorFunction"),t.isGeneratorFunction=function(t){return t="function"==typeof t&&t.constructor,!!t&&(t===v||"GeneratorFunction"===(t.displayName||t.name))},t.mark=function(t){return Object.setPrototypeOf?Object.setPrototypeOf(t,p):(t.__proto__=p,u(t,l,"GeneratorFunction")),t.prototype=Object.create(w),t},t.awrap=function(t){return{__await:t}},m(b.prototype),u(b.prototype,c,(function(){return this})),t.AsyncIterator=b,t.async=function(e,n,r,o,i){void 0===i&&(i=Promise);var a=new b(h(e,n,r,o),i);return t.isGeneratorFunction(n)?a:a.next().then((function(t){return t.done?t.value:a.next()}))},m(w),u(w,l,"Generator"),u(w,s,(function(){return this})),u(w,"toString",(function(){return"[object Generator]"})),t.keys=function(t){var e,n=Object(t),r=[];for(e in n)r.push(e);return r.reverse(),function t(){for(;r.length;){var e=r.pop();if(e in n)return t.value=e,t.done=!1,t}return t.done=!0,t}},t.values=_,E.prototype={constructor:E,reset:function(t){if(this.prev=0,this.next=0,this.sent=this._sent=void 0,this.done=!1,this.delegate=null,this.method="next",this.arg=void 0,this.tryEntries.forEach(x),!t)for(var e in this)"t"===e.charAt(0)&&n.call(this,e)&&!isNaN(+e.slice(1))&&(this[e]=void 0)},stop:function(){this.done=!0;var t=this.tryEntries[0].completion;if("throw"===t.type)throw t.arg;return this.rval},dispatchException:function(t){if(this.done)throw t;var e=this;function r(n,r){return a.type="throw",a.arg=t,e.next=n,r&&(e.method="next",e.arg=void 0),!!r}for(var o=this.tryEntries.length-1;0<=o;--o){var i=this.tryEntries[o],a=i.completion;if("root"===i.tryLoc)return r("end");if(i.tryLoc<=this.prev){var s=n.call(i,"catchLoc"),c=n.call(i,"finallyLoc");if(s&&c){if(this.prev<i.catchLoc)return r(i.catchLoc,!0);if(this.prev<i.finallyLoc)return r(i.finallyLoc)}else if(s){if(this.prev<i.catchLoc)return r(i.catchLoc,!0)}else{if(!c)throw new Error("try statement without catch or finally");if(this.prev<i.finallyLoc)return r(i.finallyLoc)}}}},abrupt:function(t,e){for(var r=this.tryEntries.length-1;0<=r;--r){var o=this.tryEntries[r];if(o.tryLoc<=this.prev&&n.call(o,"finallyLoc")&&this.prev<o.finallyLoc){var i=o;break}}var a=(i=i&&("break"===t||"continue"===t)&&i.tryLoc<=e&&e<=i.finallyLoc?null:i)?i.completion:{};return a.type=t,a.arg=e,i?(this.method="next",this.next=i.finallyLoc,f):this.complete(a)},complete:function(t,e){if("throw"===t.type)throw t.arg;return"break"===t.type||"continue"===t.type?this.next=t.arg:"return"===t.type?(this.rval=this.arg=t.arg,this.method="return",this.next="end"):"normal"===t.type&&e&&(this.next=e),f},finish:function(t){for(var e=this.tryEntries.length-1;0<=e;--e){var n=this.tryEntries[e];if(n.finallyLoc===t)return this.complete(n.completion,n.afterLoc),x(n),f}},catch:function(t){for(var e=this.tryEntries.length-1;0<=e;--e){var n,r,o=this.tryEntries[e];if(o.tryLoc===t)return"throw"===(n=o.completion).type&&(r=n.arg,x(o)),r}throw new Error("illegal catch attempt")},delegateYield:function(t,e,n){return this.delegate={iterator:_(t),resultName:e,nextLoc:n},"next"===this.method&&(this.arg=void 0),f}},t}}}]);