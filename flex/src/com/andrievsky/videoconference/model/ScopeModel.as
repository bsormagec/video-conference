package com.andrievsky.videoconference.model
{
	import com.andrievsky.videoconference.model.vo.RoomVO;
	import com.andrievsky.videoconference.model.vo.UserVO;
	import com.andrievsky.videoconference.view.loading.LoadingView;
	import com.andrievsky.videoconference.view.lobby.LobbyView;
	import com.andrievsky.videoconference.view.login.LoginView;
	import com.andrievsky.videoconference.view.publiccaster.PublicCasterView;
	
	import flash.net.NetConnection;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;
	
	import org.robotlegs.mvcs.Actor;
	
	public class ScopeModel extends Actor
	{
		public const declaredComponents:Array = [LoadingView];
		public var loadedcomponents:Array = [];
		public var logger:ILogger;
		public var me:UserVO;
		public var rooms:ArrayCollection = new ArrayCollection();
		public var users:ArrayCollection = new ArrayCollection();
		public var connection:NetConnection;
		private var dumpUsers:Array = 
			[
				new UserVO('user_id_01', 'Barack Obama'),
				new UserVO('user_id_02', 'John F. Kennedy'),
				new UserVO('user_id_03', 'Thomas Jefferson'),
				new UserVO('user_id_04', 'George Washington'),
				new UserVO('user_id_05', 'Abraham Lincoln')
			];
		
		public function init():void
		{
			var loggerImplementation:TraceTarget = new TraceTarget(); 
			loggerImplementation.includeCategory = true;
			loggerImplementation.includeDate = true;
			loggerImplementation.includeLevel = true;
			loggerImplementation.includeTime = true;
			loggerImplementation.level = LogEventLevel.ALL;
			Log.addTarget(loggerImplementation);
			logger = Log.getLogger("TraceTarget");
		}
		
		public function getDumpUsers():Array
		{
			return dumpUsers;
		}
	}
}