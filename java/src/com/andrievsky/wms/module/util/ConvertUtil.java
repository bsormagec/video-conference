package com.andrievsky.wms.module.util;

import java.util.ArrayList;

import com.wowza.wms.amf.AMFDataMixedArray;

public class ConvertUtil {

	public static ArrayList<String> AMFDataMixedArrayToArrayListString(AMFDataMixedArray value) {
		AMFDataMixedArray declaredUsers = value;
		int len = declaredUsers.size();
		ArrayList<String> declaredUsersID = new ArrayList<String>();
		for(int i=0;i<len;i++)
		{
			declaredUsersID.add(declaredUsers.getString(i));
		}
		return declaredUsersID;
	}

}
