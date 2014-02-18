package com.andrievsky.wms.module.model.data;

import com.andrievsky.wms.module.util.AMFUtils;
import com.wowza.wms.amf.AMFDataObj;

public class FeedbackComposer {
	
	private static FeedbackComposer instance = new FeedbackComposer();
	public FeedbackErrorData errorData = new FeedbackErrorData();
	public FeedbackResultData resultData = new FeedbackResultData();
	public static Object error(String description)
	{
		instance.errorData.error = description;
		return instance.errorData;
	}
	public static Object result(Object value)
	{
		instance.resultData.result = value;
		return instance.resultData;
	}
	public static AMFDataObj resultAMF(Object value)
	{
		instance.resultData.result = value;
		return (AMFDataObj) AMFUtils.encodeCustomObject(instance.resultData);
	}
	
	public static AMFDataObj errorAMF(String description, int level)
	{
		instance.errorData.error = description;
		instance.errorData.level = level;
		return (AMFDataObj) AMFUtils.encodeCustomObject(instance.errorData);
	}

}
