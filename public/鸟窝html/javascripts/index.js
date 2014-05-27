/**
 ************************************************************
 * project 表单处理
 * author XinLiang
 * Mail 939898101@qq.com
 * ver version 1.0
 * time 2014-05-26
 * company : niaowo
 * Copyright : BSD License
 ************************************************************
 */
$(function($) {
    var isSaveHope = false;//是否保存过期望职位信息
    //验证=======================start
    $(".verification").each(function(){
        $(this).bind({
            blur:function(){

                var type = $(this).attr("data-type"),
                    value = $.trim($(this).val()),
                    error_id = $("#"+$(this).attr("error-id")),
                    bFail = false,
                    dataem = $(this).attr("data-em");

                $(this).css("border","1px solid #a0a0a0").next().removeClass("cur"+dataem).addClass(dataem);

                switch (type) {
                    case 'notnull':
                        if (value == '') {
                            bFail = true;
                        }
                        break;
                    case 'notchinese':
                        var notchinese = /[\u4E00-\u9FA5]/ig;
                        bFail = !notchinese.test(value);
                        break;
                    case 'email':
                        var emailReg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
                        bFail = !emailReg.test(value);
                        break;
                    case 'chinese':
                        var chineseReg = /^\s*([\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*|[a-zA-Z]{2,20}(\s+[a-zA-Z]{2,20})+)\s*$/;
                        bFail = (chineseReg.test(value) && /^\s*([\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*|[a-zA-Z][\sa-zA-Z]{3,63})\s*$/.test(value));
                }

                if(bFail){
                    error_id.css("display","block");
                }else{
                    error_id.hide();
                }

                //显示提示信息
                if(!value){
                    $(this).prev().css("display","block");
                }

            },
            focusin:function(){
                //隐藏提示信息
                var dataem = $(this).attr("data-em")
                $(this).css("border","1px solid #16a085").next().removeClass(dataem).addClass("cur"+dataem).prev().prev().hide();
            }
        });
    });
    //隐藏tip===============start
    $(".tipMsg").each(function(){
        $(this).click(function(){
            $(this).hide().next("input").focus();
        });
    });
    //登录切换==================start
    $("#loginTip").click(function(){
        $(".registerPanel").hide();
        $(this).hide();
        $("#registerTip").show();
        $("#registerBtn").parent().parent().hide();
        $("#loginBtn").parent().parent().show();
    });
    //注册切换==================start
    $("#registerTip").click(function(){
        $(".registerPanel").show();
        $(this).hide();
        $("#loginTip").show();
        $("#registerBtn").parent().parent().show();
        $("#loginBtn").parent().parent().hide();
    });
    //注册=====================start
    $("#registerBtn").click(function(){
        $("#mycaptcha").blur();
        $(".errorregister").prev().prev().blur();
        if($(".errorregister:visible").length != 0){
            return;
        }
        if($("#registerAgree:checked").length == 0){
            $( "#dialog").html("--->请同意《鸟窝用户协议》").dialog({
                modal:false,
                close:function(){}
            }).dialog( "open");
            return;
        }
        $( "#dialog").html("注册中···").dialog({
            modal:true,
            close:function(){}
        }).dialog( "open");


        $.ajax({
            dataType: "json",
            type: "post",
            url: "/accounts/registrations/ajax_create",
            data: {
                "account[email] ": $.trim($("#myemail").val()),//邮箱
                "account[password]": $.trim($("#mypwd").val()),//密码
                "account[password_confirmation]": $.trim($("#mypwdReport").val()),//确认密码
                "captcha": $("#mycaptcha").val() || "",//验证码
                "user_type": $("#user_type:checked").length != 0 ? 1 : 2//用户类型
            },
            success: function(result) {
                if (result.status == "ok") {
                    $( "#dialog").html("注册成功，正在跳转").dialog({
                        modal:true
                    }).dialog("close");
                } else {

                }
            }
        });
    });
    $("#mycaptcha").bind({
        blur:function(){
            if(!$.trim($(this).val())){
                $(this).prev().show();
                $(this).next().next().next().css("display", "block");
            }else{
                $(this).next().next().next().hide();
            }
        },
        focusin:function(){
            if($.trim($(this).val())){
                $(this).next().next().next().hide();
            }

            $(this).prev().hide();
        }
    });
    //登录=====================start
    $("#loginBtn").click(function(){
        $(".errorlogin").prev().prev().blur();
        if($(".errorlogin:visible").length != 0){
            return;
        }
        $( "#dialog").html("登录中···").dialog({
            modal:true,
            close:function(){}
        }).dialog( "open");
        $.ajax({
            dataType: "json",
            type: "post",
            url: "/accounts/sessions/ajax_create",
            data: {
                "account[email] ": $.trim($("#myemail").val()),//邮箱
                "account[password]": $.trim($("#mypwd").val())//密码
            },
            success: function(result) {
                if (result.status == "ok") {
                    $( "#dialog").html("登录成功，正在跳转").dialog({
                        modal:true
                    }).dialog("close");
                } else {

                }
            }
        });
    });

    //如果没有登录，登录提示===========start
    $(".loginTip").each(function(){
        $(this).click(function(){
            var data_msgTip = $(this).attr("data-msgTip") || "--->请登录后再操作";
            $( "#dialog").html(data_msgTip).dialog({
                modal:true,
                close:function(){}
            }).dialog( "open");
        })
    });
    $("body").append('<div id="dialog" style="background-color: #27A695;color: #fff;text-align: center;font-size: 20px" title="Basic dialog">--->请登录后再操作</div>')
    $("#dialog").dialog({
        autoOpen:false,
        modal:false,
        height:100,
        title:"系统消息",
        show:{effect:'drop', direction:'up'},
        hide:{effect:'drop', direction:'down'},
        draggable:false,
        close: function() {
            $(".verification").first().focus();
        },
        resizable:false
    });
    //搜索============start
    var searchJob = function(content, e){
        var searchJobs = content || $.trim($("#searchJobs").val());
        if(!e || e.keyCode){
            //ajax 搜索词
        }

    }
    //搜索框
    $("#searchJobs").bind({
        blur:function(){
            var value = $.trim($(this).val());
            if(!value || value == "输入职位名称，如：销售"){
                $(this).val(" 输入职位名称，如：销售")
            }
        },
        focusin:function(){
            var value = $.trim($(this).val());
            if(value == "输入职位名称，如：销售"){
                $(this).val("")
            }
            if(!isSaveHope) $(this).blur();
        },
        keyup:function(event){
            searchJob("", event);
        }
    });
    //发现标签搜索
    $(".f_btn").each(function(){
        $(this).bind({
            mouseout:function(){
                $(this).removeClass("f_current");
            },
            mouseover:function(){
                $(this).addClass("f_current");
            },
            click:function(){
                //执行搜索
                searchJob($.trim($(this).html()));
            }
        });
    });
    $("#searchJobBtn").click(searchJob);

    //期望职位标签删除=====================start
    var deleteHope = function(){
        $(".deleteHope").unbind().each(function(){
            $(this).click(function(){
                //ajax 删除数据
                var _this = $(this).parent();
                _this.hide("normal", function(){
                    _this.remove();
                });
            });
        });
    }

    deleteHope();

    //增加期望职位标签==============start
    $("#addHope").click(function(){
        var addHopeContent = $("#addHopeContent").val(),
            addHopePanelA = $("#addHopePanel a"),
            addHopePanelC = addHopePanelA.length,
            isreport = false;

        if(addHopePanelC >= 3){
            $( "#dialog").html("期望职位·标签不超过3个").dialog({
                modal:true,
                close: function() {$("#addHopeContent").focus();}
            }).dialog( "open");
            return;
        }

        if(!addHopeContent) {
            $( "#dialog").html("期望职位·标签不能为空").dialog({
                modal:true,
                close: function() {$("#addHopeContent").focus();}
                }).dialog( "open");
            return;
        }

        addHopePanelA.each(function(){
            var con = $(this).html().replace('<i class="deleteHope" title="删除">×</i>', "");
            if(con == addHopeContent){
                isreport = true;
            }
        });
        if(isreport) {
            $( "#dialog").html("期望职位·标签不能重复").dialog({
                modal:true,
                close: function() {$("#addHopeContent").focus();}
            }).dialog( "open");
            return;
        }

        $("#addHopePanel").append('<a href="javascript:void(0)" style="display: none">'+ addHopeContent +'<i class="deleteHope" title="删除">×</i></a>').children().last().show("normal");
        deleteHope();
    });

    //保存期望标签·城市
    $("#saveHopes").each(function(){
        $(this).bind({
            mouseup:function(){
                $(this).css({"padding-left":"0px","padding-top":"0px"});
                var addHopePanelA = $("#addHopePanel a"),
                    addHopePanelC = addHopePanelA.length,
                    cityHopes = $.trim($("#cityHopes").val());

                if(addHopePanelC == 0){
                    $( "#dialog").html("请添加·期望职位").dialog({
                        modal:true,
                        close:function(){
                            $("#addHopeContent").focus();
                        }
                    }).dialog( "open");
                    return;
                }

                if(!cityHopes){
                    $( "#dialog").html("请添加·期望城市").dialog({
                        modal:true,
                        close:function(){
                            $("#cityHopes").focus();
                        }
                    }).dialog( "open");
                    return;
                }

                //ajax保存期望值
            },
            mousedown:function(){
                $(this).css({"padding-left":"1px","padding-top":"1px"});
            }
        });
    });
    //刷新验证码
    $(".updateCaptcha").each(function(){
        $(this).click(function(){
            $("#captchaImg").attr("src", "/captcha?i="+new Date().getTime());
        });
    });
});